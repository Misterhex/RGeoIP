RGeoIP
======

Store IP Ranges in Redis as sorted sets for fast lookup

Installation
------------
You can download nuget package at https://www.nuget.org/packages/RGeoIP or simpily install from command line.
```
Install-Package RGeoIP
```

Usage
-----

Import [GeoLite](http://dev.maxmind.com/geoip/legacy/geolite/) legacy csv file

```csharp
var conn = ConnectionMultiplexer.Connect("localhost:6379, allowadmin=true");
var geoIP = new GeoIP(() => conn.GetDatabase());
using (var reader = new StreamReader("GeoIPCountryWhois.csv"))
{
  var count = await geoIP.ImportGeoLiteLegacyAsync(reader);
}
```

IP lookup for the country which took a few milliseconds to lookup with ( >100,000 data set). _In my windows laptop, it took ~10 ms._

```csharp
var country = await geoIP.LookupAsync("1.1.2.245");
```

Dependencies
------------

- [CsvHelper](https://github.com/JoshClose/CsvHelper)
- [StackExchange.Redis](https://github.com/StackExchange/StackExchange.Redis)

License
-------
[MIT](https://github.com/jittuu/RGeoIP/blob/master/LICENSE)

Contribute
----------

If you find any bug, please file a bug in [Github Issue](https://github.com/jittuu/RGeoIP/issues). To hack RGeoIP, please fork this repo and send me a pull request.
