import mitmproxy.http

from mitmproxy import ctx, http
import json, time

class fcm:
    def http_connect(self, flow: mitmproxy.http.HTTPFlow):
        if flow.request.host == "ak-gs-localhost.hypergryph.com":
            flow.request.host = "ak-gs.hypergryph.com"
            flow.request.port = 8443
        elif flow.request.host == "ak-as-localhost.hypergryph.com":
            flow.request.host = "ak-as.hypergryph.com"
            flow.request.port = 9443
    
    def response(self, flow: mitmproxy.http.HTTPFlow):
        logTime = "[" + time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "] "
        # if flow.request.headers['Host'] == "ak-fs.hypergryph.com" and ("/announce/Android/preannouncement.meta.json" in flow.request.path or "/announce/IOS/preannouncement.meta.json" in flow.request.path):
        #     print(logTime + "检测到已进入明日方舟")
        if flow.request.headers['Host'] == "as.hypergryph.com" and flow.request.path == "/online/v1/ping":
            returnJson = json.loads(flow.response.get_text())
            flow.response.set_text('{"result":0,"message":"OK","interval":5400,"timeLeft":-1,"alertTime":600}')
            if returnJson["message"][:6] == "您已达到本日":
                print(logTime + "明日方舟当前已达到本日在线时长上限或不在可游戏时间范围内, 已解除防沉迷限制")
            elif returnJson["timeLeft"]:
                leftTime = returnJson['timeLeft']
                leftTimeH = int(leftTime/3600)
                leftTimeM = int((leftTime-leftTimeH*3600)/60)
                leftTimeS = int(leftTime-leftTimeH*3600-leftTimeM*60)
                print(logTime + "明日方舟游戏剩余时间: " + str(leftTimeH) + " h " + str(leftTimeM) + " m " + str(leftTimeS) + " s, 已解除防沉迷限制")

addons = [
    fcm()
]
