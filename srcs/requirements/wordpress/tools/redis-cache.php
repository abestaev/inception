<?php
/**
 * Plugin Name: Redis Object Cache
 * Description: Simple Redis object cache implementation for WordPress
 * Version: 1.0.0
 * Author: Inception Project
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Check if Redis extension is available
if (!extension_loaded('redis')) {
    return;
}

// Redis configuration
define('WP_REDIS_HOST', getenv('WP_REDIS_HOST') ?: 'redis');
define('WP_REDIS_PORT', getenv('WP_REDIS_PORT') ?: 6379);
define('WP_REDIS_PASSWORD', getenv('WP_REDIS_PASSWORD') ?: '');
define('WP_REDIS_DATABASE', getenv('WP_REDIS_DATABASE') ?: 0);
define('WP_REDIS_TIMEOUT', getenv('WP_REDIS_TIMEOUT') ?: 1);
define('WP_REDIS_READ_TIMEOUT', getenv('WP_REDIS_READ_TIMEOUT') ?: 1);

// Redis cache implementation
class Redis_Object_Cache {
    private $redis;
    private $connected = false;
    
    public function __construct() {
        $this->connect();
    }
    
    private function connect() {
        try {
            $this->redis = new Redis();
            $this->redis->connect(WP_REDIS_HOST, WP_REDIS_PORT, WP_REDIS_TIMEOUT);
            
            if (WP_REDIS_PASSWORD) {
                $this->redis->auth(WP_REDIS_PASSWORD);
            }
            
            $this->redis->select(WP_REDIS_DATABASE);
            $this->connected = true;
        } catch (Exception $e) {
            $this->connected = false;
            error_log('Redis connection failed: ' . $e->getMessage());
        }
    }
    
    public function get($key, $group = 'default') {
        if (!$this->connected) {
            return false;
        }
        
        $key = $this->build_key($key, $group);
        $value = $this->redis->get($key);
        
        return $value !== false ? maybe_unserialize($value) : false;
    }
    
    public function set($key, $data, $group = 'default', $expire = 0) {
        if (!$this->connected) {
            return false;
        }
        
        $key = $this->build_key($key, $group);
        $data = maybe_serialize($data);
        
        if ($expire > 0) {
            return $this->redis->setex($key, $expire, $data);
        } else {
            return $this->redis->set($key, $data);
        }
    }
    
    public function delete($key, $group = 'default') {
        if (!$this->connected) {
            return false;
        }
        
        $key = $this->build_key($key, $group);
        return $this->redis->del($key);
    }
    
    public function flush() {
        if (!$this->connected) {
            return false;
        }
        
        return $this->redis->flushdb();
    }
    
    private function build_key($key, $group) {
        return 'wordpress:' . $group . ':' . $key;
    }
}

// Initialize Redis cache
$GLOBALS['redis_object_cache'] = new Redis_Object_Cache();

// WordPress cache functions
function wp_cache_get($key, $group = 'default') {
    global $redis_object_cache;
    return $redis_object_cache->get($key, $group);
}

function wp_cache_set($key, $data, $group = 'default', $expire = 0) {
    global $redis_object_cache;
    return $redis_object_cache->set($key, $data, $group, $expire);
}

function wp_cache_delete($key, $group = 'default') {
    global $redis_object_cache;
    return $redis_object_cache->delete($key, $group);
}

function wp_cache_flush() {
    global $redis_object_cache;
    return $redis_object_cache->flush();
}

// Add admin notice for Redis status
add_action('admin_notices', function() {
    global $redis_object_cache;
    if ($redis_object_cache->connected) {
        echo '<div class="notice notice-success"><p>✅ Redis Object Cache is active and connected!</p></div>';
    } else {
        echo '<div class="notice notice-warning"><p>⚠️ Redis Object Cache is not connected. Check Redis service.</p></div>';
    }
});
