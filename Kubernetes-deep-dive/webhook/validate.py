from flask import Flask, request, jsonify
app = Flask(__name__)
 
@app.route("/validate", methods=["POST"])
def validate():
    review = request.json
    pod = review["request"]["object"]
 
    for c in pod["spec"]["containers"]:
        if "nginx" in c["image"]:
            return deny(review, "nginx image is not allowed")
 
    sc = pod["spec"].get("securityContext", {})
    if sc.get("privileged", False):
        return deny(review, "privileged pods are not allowed")
 
    return allow(review)
 
def deny(r, msg):
    return jsonify({"response":{"uid":r["request"]["uid"],"allowed":False,
      "status":{"message":msg}}})
 
def allow(r):
    return jsonify({"response":{"uid":r["request"]["uid"],"allowed":True}})
 
# Serve HTTPS using the TLS secret mounted at /tls
# Ensure the secret `pe-webhook-tls` contains tls.crt and tls.key and is mounted in the Deployment
app.run(host="0.0.0.0", port=8443, ssl_context=('/tls/tls.crt','/tls/tls.key'))
 