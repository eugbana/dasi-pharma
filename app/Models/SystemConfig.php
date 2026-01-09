<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

/**
 * SystemConfig Model
 * 
 * Key-value configuration storage with caching support.
 */
class SystemConfig extends Model
{
    use HasFactory;

    protected $fillable = [
        'key',
        'value',
        'type',
        'group',
        'description',
    ];

    const CACHE_KEY = 'system_configs';
    const CACHE_TTL = 3600; // 1 hour

    /**
     * Get a configuration value by key.
     */
    public static function get(string $key, mixed $default = null): mixed
    {
        $configs = self::getAllCached();
        
        if (!isset($configs[$key])) {
            return $default;
        }

        return self::castValue($configs[$key]['value'], $configs[$key]['type']);
    }

    /**
     * Set a configuration value.
     */
    public static function set(string $key, mixed $value): bool
    {
        $config = self::where('key', $key)->first();
        
        if ($config) {
            $config->update(['value' => (string) $value]);
        } else {
            self::create([
                'key' => $key,
                'value' => (string) $value,
                'type' => is_numeric($value) ? 'number' : (is_bool($value) ? 'boolean' : 'string'),
            ]);
        }

        self::clearCache();
        return true;
    }

    /**
     * Get all configurations grouped.
     */
    public static function getAllGrouped(): array
    {
        return self::all()->groupBy('group')->toArray();
    }

    /**
     * Get all configurations as key-value array.
     */
    public static function getAllCached(): array
    {
        return Cache::remember(self::CACHE_KEY, self::CACHE_TTL, function () {
            return self::all()->keyBy('key')->map(function ($config) {
                return [
                    'value' => $config->value,
                    'type' => $config->type,
                ];
            })->toArray();
        });
    }

    /**
     * Clear the configuration cache.
     */
    public static function clearCache(): void
    {
        Cache::forget(self::CACHE_KEY);
    }

    /**
     * Cast value to the appropriate type.
     */
    protected static function castValue(mixed $value, string $type): mixed
    {
        return match ($type) {
            'number' => is_numeric($value) ? (float) $value : 0,
            'boolean' => filter_var($value, FILTER_VALIDATE_BOOLEAN),
            'json' => json_decode($value, true),
            default => $value,
        };
    }

    /**
     * Get the VAT rate.
     */
    public static function getVatRate(): float
    {
        return self::get('vat_rate', 0);
    }

    /**
     * Get receipt configuration.
     */
    public static function getReceiptConfig(): array
    {
        return [
            'business_name' => self::get('receipt_business_name', ''),
            'header_title' => self::get('receipt_header_title', 'SALES RECEIPT'),
            'footer_message' => self::get('receipt_footer_message', 'Thank you for your business'),
            'vat_rate' => self::get('vat_rate', 0),
            'vat_display_text' => self::get('vat_display_text', 'VAT'),
        ];
    }
}

