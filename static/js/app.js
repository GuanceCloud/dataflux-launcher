var setup = (function () {
    function app(){
        var apiPrefix = "/api/v1/"

        var _send = function(url, method, data, headers){
            headers = headers || {}
            headers = {
                "Content-Type": "application/json"
            }

            return $.ajax(apiPrefix + url, {
                data: data,
                method: method,
                dataType:'json',
                headers: headers
            })
        };

        this.get = function(url, data, headers){
            return _send(url, "GET", data, null, headers)
        };

        this.post = function(url, data, headers){
            return _send(url, "POST", JSON.stringify(data || ""), headers)
        };
    }

    app.prototype.setting_init = function(){
        this.post("setting/init").done(function(d){
            console.log('setting init')

            window.location.href = "/check"
        });
    };

    // mysql 数据库连接测试
    app.prototype.database_ping = function(next){
        var params = {
            "host": $("#iptDBHost").val(),
            "port": $("#iptDBPort").val(),
            "user": $("#iptDBUserName").val(),
            "password": $("#iptDBUserPwd").val()
        }

        that = this

        this.get("database/ping", params).done(function(d){
            if (d.content){
                if (next){
                    window.location.href = "/database/manager"
                }
                // that.database_setup();
            }else{
                alert("MySQL 连接失败");
            }
        });
    };

    app.prototype.database_manager_add = function(){
        var data = {
            "username": $("#iptUserName").val(),
            "email": $("#iptUserEmail").val()
        }

        this.post("database/manager/add", data).done(function(d){
            if (d.content){
                window.location.href = "/redis"
            }
        });
    };

    // redis 连接测试
    app.prototype.redis_ping = function(next){
        var params = {
            "host": $("#iptRedisHost").val(),
            "port": $("#iptRedisPort").val(),
            "password": $("#iptRedisPassword").val()
        }

        this.get("redis/ping", params).done(function(d){
            if(d.content){
                if (next){
                    window.location.href = "/influxdb"
                }
            }else{
                alert("Redis 连接失败")
            }
        });
    };

    app.prototype._get_influxdb_list = function(){        
        influxdbCount = $('.influxdb-list').length

        dbs = []
        for(var i = 1; i < influxdbCount + 1; i++){
            var db = {
                "host": $("#iptInfluxDBHost" + i).val(),
                "port": $("#iptInfluxDBPort" + i).val(),
                "username": $("#iptInfluxDBUserName" + i).val(),
                "password": $("#iptInfluxDBPassword" + i).val(),
                "dbName": $("#iptInfluxDBName" + i).val(),
                "ssl": $("#ckbInfluxDBSSL" + i).is(":checked"),
                "kapacitorHost": $("#iptKapacitorHost" + i).val()
            }

            dbs.push(db);
        }

        return dbs
    };

    app.prototype.influxdb_remove = function(idx){
        this.post("influxdb/remove", {"index": idx}).done(function(d){
            if(d.content){
                window.location.href = "/influxdb"
            }
        });
    };

    // influxdb 连接测试
    app.prototype.influxdb_ping = function(next){
        dbs = this._get_influxdb_list()

        this.post("influxdb/ping", dbs).done(function(d){
            if(d.content){
                if (next){
                    window.location.href = "/setup/info"
                }
            }else{
                alert("InfluxDB 连接失败")
            }
        });
    };

    app.prototype.influxdb_add = function(){
        dbs = this._get_influxdb_list()

        this.post("influxdb/add", dbs).done(function(d){
            if(d.content){
                window.location.href = "/influxdb"
            }
        });
    };

    app.prototype.database_setup = function(){
        return this.post("database/setup");
    };

    app.prototype.database_manager_create = function(){
        return this.post("database/manager/create");
    };

    app.prototype.influxdb_setup = function(){
        return this.post("influxdb/setup");
    };


    app.prototype.do_setup = function(){
        that = this
        this.database_setup().done(function(d){
            if(d.content){
                $('.well-mysql').addClass('success');

                return that.database_manager_create();
            }
        }).done(function(d){
            if (d.content){
                $('.well-manager').addClass('success');
                $('.well-redis').addClass('success');

                return that.influxdb_setup()
            }
        }).done(function(d){
            if (d.content){
                $('.well-influxdb').addClass('success');

                window.location.href = "/config/review"
            }
        });
    };

    return new app();
})();