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

    this.switch_ping_button = function(jqObj, status){
      var jqI = jqObj.children('i');

      if(status == 'success'){
        jqObj.removeClass('btn-warning btn-danger');
        jqObj.addClass('btn-success');

        jqI.removeClass('glyphicon-question-sign glyphicon-remove-sign');
        jqI.addClass('glyphicon-ok-sign');
      }else if(status == 'error'){
        jqObj.removeClass('btn-warning btn-success');
        jqObj.addClass('btn-danger');

        jqI.removeClass('glyphicon-question-sign glyphicon-ok-sign');
        jqI.addClass('glyphicon-remove-sign');
      }
    };

    this.go = function(path){
      window.location.href = path + "?" + (new Date().valueOf());
    };

    this.get = function(url, data, headers){
      return _send(url, "GET", data, null, headers)
    };

    this.post = function(url, data, headers){
      return _send(url, "POST", JSON.stringify(data || ""), headers)
    };
  }

  app.prototype.setting_init = function(){
    var that = this;

    this.post("setting/init").done(function(d){
      that.go("/check");
    });
  };

  // mysql 数据库连接测试
  app.prototype.database_ping = function(next){
    var that = this;
    var params = {
      "host": $("#iptDBHost").val(),
      "port": $("#iptDBPort").val(),
      "user": $("#iptDBUserName").val(),
      "password": $("#iptDBUserPwd").val()
    }


    this.get("database/ping", params).done(function(d){
      if (d.content){
        that.switch_ping_button($('#btnConnectTtest'), 'success');
        if (next){
          that.go("/redis");
        }
      }else{
        that.switch_ping_button($('#btnConnectTtest'), 'error');
      }
    });

    return false;
  };

  // redis 连接测试
  app.prototype.redis_ping = function(next){
    var that = this;
    var params = {
      "host": $("#iptRedisHost").val(),
      "port": $("#iptRedisPort").val(),
      "password": $("#iptRedisPassword").val()
    }

    this.get("redis/ping", params).done(function(d){
      if(d.content){
        that.switch_ping_button($('#btnConnectTtest'), 'success');
        if (next){
          that.go("/influxdb");
        }
      }else{
        that.switch_ping_button($('#btnConnectTtest'), 'error');
      }
    });
  };

  app.prototype._get_influxdb_list = function(){
    var influxdbCount = $('.influxdb-list').length

    var dbs = []
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
    var that = this;
    this.post("influxdb/remove", {"index": idx}).done(function(d){
      if(d.content){
        that.go("/influxdb");
      }
    });
  };

  // influxdb 连接测试
  app.prototype.influxdb_ping = function(next){
    var dbs = this._get_influxdb_list()
    var that = this;

    this.post("influxdb/ping", dbs).done(function(d){
      if(d.content){
        var hasError = false;
        for(var i = 0; i < d.content.length; i++){
          var db = d.content[i]

          if (db.pingError){
            $(".influxdb-list:eq(" + i + ")").addClass('error')
            hasError = true
            that.switch_ping_button($('#btnConnectTtest'), 'error');
          }else{
            $(".influxdb-list:eq(" + i + ")").removeClass('error');
            that.switch_ping_button($('#btnConnectTtest'), 'success');
          }
        }

        if (next && !hasError){
          that.go("/other");
        }
      }else{
        alert("InfluxDB 连接失败");
      }
    });
  };

  app.prototype.influxdb_add = function(){
    var dbs = this._get_influxdb_list()
    var that = this;

    this.post("influxdb/add", dbs).done(function(d){
      if(d.content){
        that.go("/influxdb");
      }
    });
  };

  app.prototype.other_config = function(){
    var that = this;
    var data = {
      "manager":{
        "username": $("#iptUserName").val(),
        "email": $("#iptUserEmail").val()
      },
      "domain": $("#iptDomain").val()
    }

    this.post("other/config", data).done(function(d){
      if (d.content){
        that.go("/setup/info");
      }
    });
  };

  app.prototype.database_setup = function(){
    return this.post("database/setup").done(function(d){
      if(d.content){
        $('.well-mysql').addClass('success');
      }
    });
  };

  app.prototype.database_manager_create = function(){
    return this.post("database/manager/create").done(function(d){
      if (d.content){
        $('.well-manager').addClass('success');
        $('.well-redis').addClass('success');
      }
    });
  };

  app.prototype.influxdb_setup = function(){
    return this.post("influxdb/setup").done(function(d){
      if (d.content){
        $('.well-influxdb').addClass('success');
      }
    });
  };


  app.prototype.do_setup = function(){
    var that = this

    $('#btnDoSetup').attr("disabled","disabled");
    this.database_setup().then(function(){
      return that.database_manager_create();
    }).then(function(){
      return that.influxdb_setup();
    }).then(function(d){
      if (d.content){
        that.go("/config/review");
      }
    }).done(function(){
      $('#btnDoSetup').removeAttr("disabled");
    });
  };


  app.prototype.config_item_checked_all = function(){
    $('#btnConfigmapCreate').attr("disabled", $('.config-review :checkbox:not(:checked)').length != 0);
  };

  app.prototype.configmap_create = function(){
    var that = this;
    var maps = {};

    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      maps[key] = me.val();
    });

    this.post("configmap/create", maps).then(function(d){
      that.go("/service/config");
    });
  };


  app.prototype.service_create = function(){
    var that = this;

    var configs = {};
    var images = {};

    $('div.app-image :text').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      images[key] = {"imagePath": me.val()};
    });

    configs['imageRegistry'] = $('#iptImageRegistry').val();
    configs['images'] = images;

    this.post("service/create", configs).then(function(d){
      if (d.content){
        that.go("/service/status");
      }
    });
  };

  app.prototype.refresh_service_status = function(){
    var that = this;

    this.get('service/status').then(function(d){
      var services = d.content || [];
      var hasPendding = false;

      $.each(services, function(idx, item){
        var jqImgDiv = $('#img_' + item.key);
        var jqI = jqImgDiv.children('i');

        jqI.removeClass('glyphicon-repeat glyphicon-ok-circle glyphicon-remove-circle');
        if(item.Progressing == 'True'){
          jqI.addClass('glyphicon-cog');

          hasPendding = true;
        }else if(item.Available == 'True'){
          jqI.addClass('glyphicon-ok-circle');
        }else{
          jqI.addClass('glyphicon-remove-circle');
        }

        $('#img_path_' + item.key).text(item.fullImagePath);
      });

      if (hasPendding){
        window.setTimeout(function(){that.refresh_service_status();}, 5000);
      }
    });
  };

  return new app();
})();
