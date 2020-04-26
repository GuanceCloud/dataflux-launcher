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
      return _send(url, "GET", data, headers)
    };

    this.post = function(url, data, headers){
      return _send(url, "POST", JSON.stringify(data || ""), headers)
    };
  }

  app.prototype.setting_init = function(){
    var that = this;

    this.post("setting/init").done(function(d){
      that.go("/check");
      // that.go("/database");
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

    $("#validateForm").validate();
    isValid = $('#validateForm').valid();

    if (!isValid)
      return false;

    this.get("database/ping", params).done(function(d){
      if (d.content && d.content.connected){
        that.switch_ping_button($('#btnConnectTtest'), 'success');
        var dbNames = d.content.dbNames || [];
        var jqSpan = $('#spanExistsDB')

        if (dbNames.length > 0) {
          jqSpan.text(dbNames.join('、 '));
          jqSpan.parent().removeClass('hide');
        }else{
          $('#spanExistsDB').parent().addClass('hide');
        }

        if (next && dbNames.length == 0){
          that.go("/install/redis");
        }
      }else{
        $('#spanExistsDB').parent().addClass('hide');
        that.switch_ping_button($('#btnConnectTtest'), 'error');
      }
    });
  };

  // redis 连接测试
  app.prototype.redis_ping = function(next){
    var that = this;
    var params = {
      "host": $("#iptRedisHost").val(),
      "port": $("#iptRedisPort").val(),
      "password": $("#iptRedisPassword").val()
    }

    $("#validateForm").validate();
    isValid = $('#validateForm').valid();

    if (!isValid)
      return false;

    this.get("redis/ping", params).done(function(d){
      if(d.content){
        that.switch_ping_button($('#btnConnectTtest'), 'success');
        if (next){
          that.go("/install/influxdb");
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
        // "dbName": $("#iptInfluxDBName" + i).val(),
        "ssl": $("#ckbInfluxDBSSL" + i).is(":checked"),
        "defaultRP": $("#sltInfluxRP" + i).val()
      }

      $("#validateForm").validate();
      isValid = $('#validateForm').valid();

      if (!isValid)
        return [];

      dbs.push(db);
    }

    return dbs
  };

  app.prototype.influxdb_remove = function(idx){
    var that = this;
    this.post("influxdb/remove", {"index": idx}).done(function(d){
      if(d.content){
        that.go("/install/influxdb");
      }
    });
  };

  // influxdb 连接测试
  app.prototype.influxdb_ping = function(next){
    var dbs = this._get_influxdb_list()
    var that = this;

    if (dbs.length == 0) {
      return false;
    }

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
          that.go("/install/other");
        }
      }else{
        alert("InfluxDB 连接失败");
      }
    });
  };

  app.prototype.influxdb_add = function(){
    var dbs = this._get_influxdb_list()
    var that = this;

    if (dbs.length == 0) {
      return false;
    }

    this.post("influxdb/add", dbs).done(function(d){
      if(d.content){
        that.go("/install/influxdb");
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
      "domain": $("#iptDomain").val(),
      "subDomain": {}
    };

    $('.sub-domain-group input').each(function(idx, item) {
      var jqMe = $(item);
      var name = jqMe.attr('name');

      data.subDomain[name] = jqMe.val();
    });

    data.tls = {
      "certificatePrivateKey": $('#certificatePrivateKey').val(),
      "certificateContent": $('#certificateContent').val()
    }

    data.nodeInternalIP = $('#iptNodeIps').val();

    $("#validateForm").validate();
    isValid = $('#validateForm').valid();

    if (!isValid)
      return false;

    this.post("other/config", data).done(function(d){
      if (d.content){
        that.go("/install/setup/info");
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

  app.prototype.certificate_create = function(){
    return this.post("certificate/create").done(function(d){
      if (d.content){
        $('.well-certificate').addClass('success');
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
    }).then(function(){
      return that.certificate_create();
    }).then(function(d){
      if (d.content){
        that.go("/install/config/review");
      }
    }).done(function(){
      $('#btnDoSetup').attr("disabled", false);
    });
  };


  app.prototype.config_item_checked_all = function(){
    $('#btnConfigmapCreate').attr("disabled", $('.config-review :checkbox:not(:checked)').length != 0);
  };

  app.prototype.configmap_create = function(){
    var that = this;
    var maps = {};

    $('#btnConfigmapCreate').attr("disabled","disabled");

    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      maps[key] = me.val();
    });

    this.post("configmap/create", maps).then(function(d){
      that.go("/install/service/config");
    }).done(function(){
      that.config_item_checked_all();
    });
  };


  app.prototype.service_create = function(){
    var that = this;

    var configs = {};
    var images = {};

    $('#btnServiceCreate').attr("disabled", true);
    $('div.app-image :text').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      images[key] = {"imagePath": me.val()};
    });

    $('div.app-image :hidden').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      images[key]['replicas'] = me.val();
    });

    // configs['imageRegistry'] = $('#iptImageRegistry').val();
    configs['imageDir'] = $('#iptImageDir').val();
    // configs['imageRegistryUser'] = $('#iptImageRegistryUser').val();
    // configs['imageRegistryPwd'] = $('#iptImageRegistryPwd').val();
    configs['storageClassName'] = $('#sltStorageClassName').val();
    configs['images'] = images;

    this.post("service/create", configs).then(function(d){
      if (d.content){
        that.go("/install/service/status");
      }
    }).done(function (){
      $('#btnServiceCreate').attr("disabled", false);
    });
  };

  app.prototype.refresh_service_status = function(){
    var that = this;

    this.get('service/status').then(function(d){
      var services = d.content || [];
      var hasPendding = false;
      var total = 0;
      var penddingCount = 0;

      // return
      $.each(services, function(idx, ns){
        $.each(ns.services, function(idx, item) {
          var jqImgDiv = $('#img_' + item.key);
          var jqI = jqImgDiv.find('i');

          if (item.replicas > 0){
            total = total + 1;

            jqI.removeClass('icon-success service-pendding');
            if(!item.fullImagePath || item.replicas != item.availableReplicas ){
              jqI.addClass('service-pendding');

              hasPendding = true;
              penddingCount = penddingCount + 1;
            }else if(item.replicas == item.availableReplicas){
              jqI.addClass('icon-success');
            }

            $('#img_path_' + item.key).text(item.fullImagePath);
          }
        });
      });

      $("#successTotal").text(total - penddingCount);
      $("#statusTotal").text(" / " + total);

      if (hasPendding){
        window.setTimeout(function(){that.refresh_service_status();}, 5000);
      }else{
        that.post('version/save').then(function(d){
          if(!d.content){
            alert("写入版本失败，刷新本页面可以重试写入版本。");
          }else{
            $('#spanStatusInfo').show();
          }
        }).fail(function(d){
          alert("写入版本失败，刷新本页面可以重试写入版本。");
        });
      }
    });
  };

  /* update */
  app.prototype.up_service_status = function(){
    var that = this;

    this.get('up/service/status').then(function(d){
      var services = d.content || [];
      var hasPendding = false;
      var hasUnUpdated = false;

      $.each(services, function(idx, ns){
        $.each(ns.services, function(idx, item) {
          var jqImgDiv = $('#img_' + item.key);
          var jqOldI = jqImgDiv.find('p.old i');
          var jqNewI = jqImgDiv.find('p.new i');

          jqOldI.removeClass('text-warning glyphicon glyphicon-ban-circle icon-success service-pendding');
          jqNewI.removeClass('text-warning glyphicon glyphicon-ban-circle icon-success service-pendding');

          if(item.newImagePath == item.fullImagePath){
            if(!item.fullImagePath || item.replicas != item.availableReplicas ){
              jqNewI.addClass('service-pendding');
              jqOldI.addClass('text-warning glyphicon glyphicon-ban-circle');

              hasPendding = true;
            }else if(item.replicas == item.availableReplicas){
              jqNewI.addClass('icon-success');
              jqOldI.addClass('text-warning glyphicon glyphicon-ban-circle');
            }
          }else{
            if(!item.fullImagePath || item.replicas != item.availableReplicas ){
              jqOldI.addClass('service-pendding');
              jqNewI.addClass('text-warning glyphicon glyphicon-ban-circle');

              hasPendding = true;
            }else if(item.replicas == item.availableReplicas){
              jqOldI.addClass('icon-success');
              jqNewI.addClass('text-warning glyphicon glyphicon-ban-circle');
            }
          }

          if (item.newImagePath != item.fullImagePath || item.replicas != item.availableReplicas){
            hasUnUpdated = true
          }
        });
      });

      $('#btnNext').attr('disabled', hasUnUpdated);
      if (hasPendding){
        window.setTimeout(function(){that.up_service_status();}, 3000);
      }
    });
  };

  app.prototype.up_service_update = function(){
    var that = this;

    $('#btnDoUpdate').attr("disabled", true);
    this.post('up/service/update').then(function(d){
      // window.setTimeout(function(){that.up_service_status();}, 1000);
      that.go("/up/service/status");
    });
  };

  app.prototype.up_config_check_edit = function(){
    var jqCheckbox = $('label.config-check-edit > :checkbox');
    var btnConfigmapUpdate = $('#btnConfigmapUpdate');

    btnConfigmapUpdate.attr("disabled", true);
    jqCheckbox.each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      if(me.is(":checked")){
        $('#collapse' + key).addClass('checked-edit');

        btnConfigmapUpdate.attr("disabled", false);
      }else{
        $('#collapse' + key).removeClass('checked-edit');
      }
    });
  };


  app.prototype.configmap_update = function(){
    var that = this;
    var maps = {};

    $('#btnConfigmapUpdate').attr("disabled", true);
    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      // 只更新勾选了 “升级配置” 的配置项
      if ($('#chk' + key).is(":checked")){
        maps[key] = me.val();
      }

    });

    if (Object.keys(maps).length == 0){
      alert("未勾选需要升级的配置项。");

      return;
    }

    this.post("up/configmap/update", maps).then(function(d){
      that.go("/up/database");
    }).done(function(){

    });
  };


  app.prototype.database_update = function(){
    var that = this;
    var count = 0;

    $('#btnDatabaseUpdate').attr("disabled", true);
    jqProject = $('.upgrade-sql-list');

    // window.setTimeout(function() {
    jqProject.each(function(idx, item){
      var me = $(item);
      var project = me.data('project');
    
      that.post("up/database/update", {'project': project}).then(function(d){
        count = count + 1;

        if (count == jqProject.length){
          that.go("/up/service");
          // that.get('service/redeploy/all').then(function(d){
          //   that.go("/up/service/status");
          // });
        }
      }).done(function(){
        // $('#btnDatabaseUpdate').attr("disabled", false);
      });

    });
    // }, 10);
  };

  // app.prototype.redeploy_all = function(){
  //   var that = this;

  //   $('#btnRedeployAll').attr("disabled", 'disabled');

  //   this.get('service/redeploy/all').then(function(d){
  //     that.go("/up/service/status");
  //   });
  // };

  app.prototype.new_configmap_create = function(){
    var that = this;
    var maps = {};

    $('#btnConfigmapCreate').attr("disabled","disabled");

    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');

      maps[key] = me.val();
    });

    this.post("up/configmap/create", maps).then(function(d){
      that.go("/up/configmap");
    }).done(function(){
      that.config_item_checked_all();
    });
  };

  app.prototype.open_setting = function(key, title){   
    var that = this;
    var jqSettingTextarea = $("#settingTextarea"); 
    var params = {
      "key": key
    };

    $("#settingModalLabel").text(title);
    $("#settingModalButtonOK").attr('disabled', true);
    $("#settingTextarea + .CodeMirror").remove();
    $("#spanYAMLError").hide();

    jqSettingTextarea.data('configKey', key);

    this.get('setting/get', params).done(function(d){
      jqSettingTextarea.val(d.content);
      $("#settingModal").modal("show");

      setTimeout(function(){
        var codemirrorEditor = CodeMirror.fromTextArea(document.getElementById('settingTextarea'), {
          mode: 'yaml',
          lineNumbers: true,
          tabSize: 2
        });

        codemirrorEditor.on('change', function(){
          $("#settingModalButtonOK").attr('disabled', false);
        });

        jqSettingTextarea.data('codemirror', codemirrorEditor);
      }, 200);
    });
  };

  app.prototype.save_setting = function(){
    var jqSettingTextarea = $("#settingTextarea");
    var codemirrorEditor = jqSettingTextarea.data('codemirror');
    var key = jqSettingTextarea.data('configKey');
    var val = codemirrorEditor.getValue();

    var dict = null;

    $("#settingModalButtonOK").attr('disabled', true);
    try {
      dict = jsyaml.safeLoad(val);
    } catch (err) {
      console.log(err);
      $("#spanYAMLError").show();
    }

    if (dict){
      var data = {
        "key": key,
        "content": dict
      };

      this.post('setting/save', data).done(function(d){
        $("#settingModal").modal("hide");
        $("#settingModalButtonOK").attr('disabled', false);
      });
    }
  };

  return new app();
})();
