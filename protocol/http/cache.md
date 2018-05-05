缓存优化：

`Keep-Alive`

```
Connection: Keep-Alive
Keep-Alive: timeout=120,max=5
```

`Last-Modified/If-Modified-Since`

`304 Not Modified`

```
Last-Modified: Fri , 12 May 2015 13:10:33 GMT
```

```
If-Modified-Since : Fri , 12 May 2015 13:10:33 GMT
```

ETag/If-None-Match

```
ETag: W/"a627ff1c9e65d2dede2efe0dd25efb8c"
```

`304 Not Modified`


`Expires/Cache-Control`

```
Expires: Thu, 19 Nov 2015 15:00:00 GMT
Cache-Control:max-age=3600
```

```
Cache-Control: max-age=3600
```

Cookie/Session