function app(){
    this.apiPrefix = "/api/v1/"

    this.send = function(url, method, data, content, header){
        header = header || {}
        header = {
            "content-type": "application/json"
        }

        return $.ajax(this.apiPrefix + url, {
            data: data,
            method: method,
            content: content,
            header: header
        })
    }

    this.get = function(url, data, header){
        return this.send(url, "GET", data, null, header)
    }

    this.post = function(url, data, content, header){
        return this.send(url, "POST", data, content, header)
    }
}

// mysql 数据库连接测试
app.prototype.database_ping = function(){
    var params = {
        "host": $("#iptDBHost").val(),
        "port": $("#iptDBPort").val(),
        "user": $("#iptDBUserName").val(),
        "password": $("#iptDBUserPwd").val()
    }

    that = this

    this.get("database/ping", params).done(function(d){
        if (d.content){
            that.database_setup();
        }else{
            alert("连接失败");
        }
    });
};

app.prototype.database_setup = function(){
    this.post("database/setup").done(function(d){
        console.log(d)
    });
};

// redis 连接测试
app.prototype.redis_ping = function(){

};

var setup = new app();