--init.lua
--led blink
lighton=0
pin_led=4
gpio.mode(pin_led,gpio.OUTPUT)
tmr.alarm(0,500,1,function()
  if lighton==0 then
    lighton=1
    gpio.write(pin_led,gpio.HIGH)
  else
    lighton=0
    gpio.write(pin_led,gpio.LOW)
  end
end)

--WIFI connect

print('Setting up WIFI...')
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="DacWords"
station_cfg.pwd="icetouch"
station_cfg.save=false
wifi.sta.config(station_cfg)

wifi.sta.connect()

-- 定义函数
function reconnect_wifi()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
        wifi_connetion = 0
    else
        print('IP is ' .. wifi.sta.getip())
        tmr.stop(1) 
        wifi_connetion = 1
    end
end

tmr.alarm(1, 1000, tmr.ALARM_AUTO, reconnect_wifi) 

temp = 0
hum = 0
tmr.alarm(2, 12000, 1, function()
--if wifi connected, send HTTP data with type 5
  if wifi_connetion == 1 then
    dofile("dht_test.lua") 
    str=",;Humidity,"..humi..";Temperature,"..temp 
    print(str.." len: "..string.len(str))
    sk=net.createConnection(net.TCP, 0) --normal link
    sk:on("receive", function(sck, c) print(c) end ) 
    sk:on("disconnection", function() print("tcp:disconnection") end )
    sk:connect(80,"183.230.40.33") --与OneNET建立TCP连接

    sk:on("connection", function(sck,c)
    print("tcp:connection")
    --HTTP 1.0: socket closed right after communication
    --type=5 format: ,;xxx,x;xxx,x
    sk:send(
    "POST /devices/29471808/datapoints?type=5 HTTP/1.0\r\n"
    .."api-key: vFQxX68uiWnEUqm5Y6Ti2FpMqfE=\r\n"
    .."Host: api.heclouds.com\r\n"
    .."Content-Length: "..string.len(str).."\r\n\r\n"
    ..str.."\r\n\r\n")
    end)
  end
end)
