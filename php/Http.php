<?php

namespace PhpToro\Plugins\Http;

class Http
{
    public static function get(string $url, array $options = []): array
    {
        return self::request(array_merge($options, ['url' => $url, 'method' => 'GET']));
    }

    public static function post(string $url, string $body = '', array $options = []): array
    {
        return self::request(array_merge($options, ['url' => $url, 'method' => 'POST', 'body' => $body]));
    }

    public static function put(string $url, string $body = '', array $options = []): array
    {
        return self::request(array_merge($options, ['url' => $url, 'method' => 'PUT', 'body' => $body]));
    }

    public static function delete(string $url, array $options = []): array
    {
        return self::request(array_merge($options, ['url' => $url, 'method' => 'DELETE']));
    }

    public static function request(array $options): array
    {
        $json = phptoro_native_call('http', 'request', json_encode($options));
        return json_decode($json, true) ?? [];
    }
}
