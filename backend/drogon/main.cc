#include <drogon/drogon.h>
#include <json/json.h>

int main()
{
    drogon::app()
        .addListener("0.0.0.0", 8005)
        .setThreadNum(4)
        .registerHandler(
            "/",
            [](const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback)
            {
                Json::Value json;
                json["message"] = "UMF-DevKit Drogon service is running.";
                json["framework"] = "Drogon";
                json["language"] = "C++";
                auto resp = drogon::HttpResponse::newHttpJsonResponse(json);
                callback(resp);
            },
            {drogon::Get})
        .registerHandler(
            "/health",
            [](const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback)
            {
                Json::Value json;
                json["status"] = "ok";
                json["service"] = "umf-drogon";
                json["version"] = "1.0.0";
                auto resp = drogon::HttpResponse::newHttpJsonResponse(json);
                callback(resp);
            },
            {drogon::Get})
        .registerHandler(
            "/hello",
            [](const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback)
            {
                Json::Value json;
                json["message"] = "Hello from Drogon!";
                json["framework"] = "Drogon";
                json["language"] = "C++";
                auto resp = drogon::HttpResponse::newHttpJsonResponse(json);
                callback(resp);
            },
            {drogon::Get})
        .registerHandler(
            "/greet",
            [](const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback)
            {
                auto jsonBody = req->getJsonObject();
                Json::Value resp_json;
                if (jsonBody && jsonBody->isMember("name"))
                {
                    std::string name = (*jsonBody)["name"].asString();
                    resp_json["greeting"] = "Hello, " + name + "! — from Drogon (C++)";
                }
                else
                {
                    resp_json["error"] = "name is required";
                    auto resp = drogon::HttpResponse::newHttpJsonResponse(resp_json);
                    resp->setStatusCode(drogon::k400BadRequest);
                    callback(resp);
                    return;
                }
                auto resp = drogon::HttpResponse::newHttpJsonResponse(resp_json);
                callback(resp);
            },
            {drogon::Post})
        .run();

    return 0;
}
