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

    this.config_format = function(val, format){
      var success = true;

      if (format == 'yaml'){
        try {
          dict = jsyaml.safeLoad(val);
        } catch (err) {
          success = false;
        }
      }else if(format == 'json'){
        try{
          JSON.parse(val);
        } catch(err){
          success = false;
        }
      }else if(format == 'js'){
        try{
          eval(val);
        } catch(err){
          success = false;
        }
      }

      return success;
    }
  };

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
      "ssl": $("#ckbRedisSSL").is(":checked"),
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
          that.go("/install/elasticsearch");
        }
      }else{
        that.switch_ping_button($('#btnConnectTtest'), 'error');
      }
    });
  };

  // elasticsearch 连接测试
  app.prototype.elasticsearch_ping = function(next){
    var that = this;
    var objAliyunOpenStore = $('#chkAliyunOpenStore');
    var objAWSUltrawarm = $('#chkAWSUltrawarm');
    var objOpenStoreSettings = $('#txtOpenStoreSettings');
    var provider = $("#sltESProvider").val()

    var params = {
      "host": $("#iptESHost").val(),
      "port": $("#iptESPort").val(),
      "ssl": $("#ckbElasticsearchSSL").is(":checked"),
      "user": $("#iptESUserName").val(),
      "password": $("#iptESUserPwd").val(),
      "provider": provider,

      "isOpenStore": provider == 'aliyun' && objAliyunOpenStore.is(':checked'),
      "isUltrawarm": provider == 'aws' && objAWSUltrawarm.is(':checked'),

      'openStoreSettings': objOpenStoreSettings.val()
    }

    $("#validateForm").validate();
    isValid = $('#validateForm').valid();

    if (!isValid)
      return false;

    this.post("elasticsearch/ping", params).done(function(d){
      if (d.content){
        that.switch_ping_button($('#btnConnectTtest'), 'success');
        if (next){
          that.go("/install/influxdb");
        }
      }else{
        that.switch_ping_button($('#btnConnectTtest'), 'error');
      }
    });
  };

  app.prototype.elasticsearch_provider_change = function(){
    var provider = $('#sltESProvider').val();
    var objAliyunOpenStore = $('#chkAliyunOpenStore');
    var objAWSUltrawarm = $('#chkAWSUltrawarm');

    $('#txtOpenStoreSettings').parents('.form-group').addClass('hide');
    objAliyunOpenStore.prop('checked', false);
    objAWSUltrawarm.prop('checked', false);

    if (provider == 'aliyun'){
      objAliyunOpenStore.parent().removeClass('hide');
      objAWSUltrawarm.parent().addClass('hide');
    }else if (provider == 'aws'){
      objAliyunOpenStore.parent().addClass('hide');
      objAWSUltrawarm.parent().removeClass('hide');
    }else{
      objAliyunOpenStore.parent().addClass('hide');
      objAWSUltrawarm.parent().addClass('hide');
    }
  };

  app.prototype.elasticsearch_openstore_change = function(){
    var objAliyunOpenStore = $('#chkAliyunOpenStore');
    var checked = objAliyunOpenStore.is(':checked');

    if (checked){
      $('#txtOpenStoreSettings').parents('.form-group').removeClass('hide');
    }else{
      $('#txtOpenStoreSettings').parents('.form-group').addClass('hide');
    }
  };

  app.prototype._get_influxdb_list = function(){
    var influxdbCount = $('.influxdb-list').length

    var dbs = []
    for(var i = 1; i < influxdbCount + 1; i++){
      var engine = $('input:radio[name=radioSeriesEngine' + i + ']:checked').val();
      var db = {
        "host": $("#iptInfluxDBHost" + i).val(),
        "port": $("#iptInfluxDBPort" + i).val(),
        "username": $("#iptInfluxDBUserName" + i).val(),
        "password": $("#iptInfluxDBPassword" + i).val(),
        // "dbName": $("#iptInfluxDBName" + i).val(),
        "ssl": $("#ckbInfluxDBSSL" + i).is(":checked"),
        "defaultRP": $("#sltInfluxRP" + i).val(),
        "engine": engine
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

  app.prototype.tls_status_change = function(obj){
    var isChecked = $(obj).is(":checked");

    $("#certificatePrivateKey").attr("disabled", !isChecked);
    $("#certificateContent").attr("disabled", !isChecked);
  };

  app.prototype.aksk_save = function(){
    var that = this;
    var data = {
      "cc":{
        "ak": $("#iptCCAK").val(),
        "sk": $("#iptCCSK").val()
      },
      "dial":{
        "ak": $("#iptDialAK").val(),
        "sk": $("#iptDialSK").val(),
        "dataway_url": $("#iptDialDataWay").val(),
      },
    };

    $("#validateForm").validate();
    isValid = $('#validateForm').valid();

    if (!isValid)
      return false;

    this.post("aksk/save", data).done(function(d){
      if (d.content){
        that.go("/install/other");
      }
    });
  };

  app.prototype.other_config = function(){
    var that = this;
    var data = {
      "manager":{
        "username": $("#iptUserName").val().trim(),
        "email": $("#iptUserEmail").val().trim()
      },
      "studioHideHelp": $("#ckbStudioHideHelp").is(":checked"),
      "domain": $("#iptDomain").val().trim(),
      "subDomain": {},
      "kodoLoadBalancerType": !$('#ckbKodoLBType').is(":checked")? "internet": "intranet"
    };

    $('.sub-domain-group input:text').each(function(idx, item) {
      var jqMe = $(item);
      var name = jqMe.attr('name');

      data.subDomain[name] = jqMe.val().trim();
    });

    data.tls = {
      "certificatePrivateKey": $('#certificatePrivateKey').val(),
      "certificateContent": $('#certificateContent').val(),
      "tlsDisabled": ! $('#ckbTlsEnabled').is(":checked"),
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
        $('.well-mysql').removeClass('error').addClass('success');
      }
    }).fail(function(d){
      $('.well-mysql').removeClass('success').addClass('error');
    });
  };

  app.prototype.database_manager_create = function(){
    return this.post("database/manager/create").done(function(d){
      if (d.content){
        $('.well-manager').removeClass('error').addClass('success');
        $('.well-redis').removeClass('error').addClass('success');
      }
    }).fail(function(d){
      $('.well-manager').removeClass('success').addClass('error');
      $('.well-redis').removeClass('success').addClass('error');
    });
  };

  app.prototype.influxdb_setup = function(){
    return this.post("influxdb/setup").done(function(d){
      if (d.content){
        $('.well-influxdb').removeClass('error').addClass('success');
      }
    }).fail(function(d){
      $('.well-influxdb').removeClass('success').addClass('error');
    });
  };

  app.prototype.elasticsearch_setup = function(){
    return this.post("elasticsearch/setup").done(function(d){
      if (d.content){
        $('.well-elasticsearch').removeClass('error').addClass('success');
      }
    }).fail(function(d){
      $('.well-elasticsearch').removeClass('success').addClass('error');
    });
  };

  app.prototype.certificate_create = function(){
    return this.post("certificate/create").done(function(d){
      if (d.content){
        $('.well-certificate').removeClass('error').addClass('success');
      }
    }).fail(function(d){
      $('.well-certificate').removeClass('success').addClass('error');
    });
  };

  app.prototype.do_setup = function(){
    var that = this;
    var jqBtnSetup = $('#btnDoSetup');

    if (jqBtnSetup.attr("disabled") == 'disabled'){
      return false;
    }

    jqBtnSetup.attr("disabled", true);

    this.database_setup().then(function(){
      return that.database_manager_create();
    }).then(function(){
      return that.influxdb_setup();
    }).then(function(){
      return that.elasticsearch_setup();
    }).then(function(){
      return that.certificate_create();
    }).then(function(d){
      if (d.content){
        that.go("/install/config/review");
      }
    }).done(function(){
      jqBtnSetup.attr("disabled", false);
    });
  };


  app.prototype.config_item_checked_all = function(){
    $('#btnConfigmapCreate').attr("disabled", !$('#chk_config :checkbox').is(':checked'));
  };

  app.prototype.format_validate = function(obj){
    var that = this;
    var me = $(obj);
    var mapFormat = me.data('format');

    var val = me.val();
    var formatErr = !that.config_format(val, mapFormat);

    me.parents('.config-item-group').removeClass('error');
    if (formatErr){
      me.parents('.config-item-group').addClass('error');
    }

    return !formatErr;
  };

  app.prototype.configmap_create = function(){
    var that = this;
    var maps = {};
    var hasErr = false;

    if ($('#btnConfigmapCreate').attr("disabled") == "disabled"){
      return false;
    }

    $('#btnConfigmapCreate').attr("disabled","disabled");
    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');
      var mapFormat = me.data('format');

      var val = me.val();
      var formatErr = !that.config_format(val, mapFormat);

      me.parents('.config-item-group').removeClass('error');
      if (!formatErr){
        maps[key] = val;
      }else{
        me.parents('.config-item-group').addClass('error');
        hasErr = true;
      }
    });

    if (!hasErr){
      this.post("configmap/create", maps).then(function(d){
        that.go("/install/service/config");
      }).done(function(){
        that.config_item_checked_all();
      });
    }else{
      alert("标红的配置项有格式错误，请修改后再试！");
    }
  };


  app.prototype.service_create = function(){
    var that = this;

    var configs = {};
    var images = {};

    if ($('#btnServiceCreate').attr("disabled") == "disabled"){
      return false;
    }

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
    configs['imagePullPolicy'] = $('#sltImagePullPolicy').val();
    configs['images'] = images;
    configs['ingressClassName'] = $('#sltIngressClassName').val();

    this.post("service/create", configs).then(function(d){
      if (d.content){
        that.go("/install/service/status");
      }
    }).done(function (){
      $('#btnServiceCreate').attr("disabled", false);
    });
  };

  app.prototype.refresh_service_status = function(mode){
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
          var jqAvailableReplicas = jqImgDiv.find('.available-replicas');
          var jqRequireReplicas = jqImgDiv.find('.require-replicas');

          if (item.replicas > 0){
            total = total + 1;

            jqI.removeClass('icon-success service-pendding');
            if(!item.fullImagePath || item.availableReplicas < item.replicas || item.unavailableReplicas != 0){
              jqI.addClass('service-pendding');

              hasPendding = true;
              penddingCount = penddingCount + 1;
            }else if(item.availableReplicas >= item.replicas){
              jqI.addClass('icon-success');
            }

            jqAvailableReplicas.text(item.availableReplicas);
            jqRequireReplicas.text(item.replicas);
            $('#img_path_' + item.key).text(item.fullImagePath);
          }
        });
      });

      $("#successTotal").text(total - penddingCount);
      $("#statusTotal").text(" / " + total);

      if (hasPendding){
        window.setTimeout(function(){that.refresh_service_status(mode);}, 5000);
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

        // 全新安装时，需要初始化 ES 的 RP，升级安装时需要进入 Launcher 容器，手工执行 ES 初始化的接口
        if(mode == 'install'){   
          // 初始化 ES 生命周期策略、模板等配置
          that.post('elasticsearch/init').then(function(d){
            if(d.content.status_code != 200){
              alert("Elasticsearch 数据初始化失败，请检查 Elasticsearch 配置信息，然后再刷新本页面。");
            }else{
              // 初始化系统工作空间
              that.post('workspace/init').then(function(d){
                if(d.content.status_code != 200){
                  alert("初始化系统工作空间失败，刷新页面重试。");
                }else{
                  that.post('metering/init').then(function(d){
                    if(d.content.status_code != 200){
                      alert("初始化 ES 计量数据索引模板失败，请排除问题后刷新页面重试。");
                    }
                  });
                }
              }).fail(function(d){
                alert("初始化系统工作空间失败，刷新页面重试。");
              });
            }
          }).fail(function(d){
            alert("Elasticsearch 数据初始化失败，请检查 Elasticsearch 配置信息，然后再刷新本页面。");
          });
        }else{
          that.get('up/update/finish').then(function(d){
            if(d.conetnt.status_code != 200){
              alert("安装完成后的配置升级失败,刷新页面可以重试!");
            }
          });
        }

        // 初始化 Studio 平台的相关配置：导入 官方 Pipeline 库、指标库、地理信息表、集成包、视图模板包
        that.post('studio/init').then(function(d){
          if (d.content.status_code != 200){
            alert("Studio 平台初始化失败，请刷新本页面重试。");
          }else{
            // 同步集成包模板到数据库
            that.post('setting/sync_integration').done(function(d){
              
            }).fail(function(d){
              alert("集成包同步失败。")
            });

            // 同步官方 Pipeline 模板到数据库
            that.post('setting/sync_pipeline').done(function(d){
              
            }).fail(function(d){
              alert("官方 Pipeline 包同步失败。")
            });

            // 同步官方 Field 列表到数据库
            that.post('setting/sync_field_list').done(function(d){
              
            }).fail(function(d){
              alert("官方 Field 库同步失败。")
            });
          }
        }).fail(function(d){
            alert("Studio 平台初始化失败，请刷新本页面重试。");
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
            if(!item.fullImagePath || item.replicas != item.availableReplicas || item.unavailableReplicas != 0 ){
              jqNewI.addClass('service-pendding');
              jqOldI.addClass('text-warning glyphicon glyphicon-ban-circle');

              hasPendding = true;
            }else if(item.availableReplicas >= item.replicas){
              jqNewI.addClass('icon-success');
              jqOldI.addClass('text-warning glyphicon glyphicon-ban-circle');
            }
          }else{
            if(!item.fullImagePath || item.availableReplicas < item.replicas){
              jqOldI.addClass('service-pendding');
              jqNewI.addClass('text-warning glyphicon glyphicon-ban-circle');

              hasPendding = true;
            }else if(item.availableReplicas >= item.replicas){
              jqOldI.addClass('icon-success');
              jqNewI.addClass('text-warning glyphicon glyphicon-ban-circle');
            }
          }

          if (item.newImagePath != item.fullImagePath || item.availableReplicas < item.replicas){
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

    if ($('#btnDoUpdate').attr("disabled") == "disabled"){
      return false;
    }

    $('#btnDoUpdate').attr("disabled", true);
    this.post('up/service/update').then(function(d){
      // window.setTimeout(function(){that.up_service_status();}, 1000);
      that.go("/up/service/status");
    });
  };

  app.prototype.up_config_check_edit = function(){
    var jqCheckbox = $('label.config-check-edit > :checkbox');
    var btnConfigmapUpdate = $('#btnConfigmapUpdate');

    if(btnConfigmapUpdate.attr("disabled") == "disabled"){
      return false;
    }

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

  // 升级步骤
  app.prototype.do_configmap_edit = function(options, complate_func){
    var that = this;
    var params = {
      "options": options || {},
      "configmaps": {}
    };
    var hasErr = false;

    if($('#btnConfigmapUpdate').attr("disabled") == "disabled"){
      return false;
    }

    $('#btnConfigmapUpdate').attr("disabled", true);
    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');
      var mapFormat = me.data('format');

      var val = me.val();
      var formatErr = !that.config_format(val, mapFormat);

      me.parents('.config-item-group').removeClass('error');

      if (!formatErr){
        // 只更新勾选了 “升级配置” 的配置项
        if ($('#chk' + key).is(":checked")){
          params["configmaps"][key] = val;
        }
      }else{
        me.parents('.config-item-group').addClass('error');
        hasErr = true;
      }

    });

    if (!hasErr){ 
      if (Object.keys(params["configmaps"]).length == 0){
        alert("未勾选需要升级的配置项。");

        return;
      }

      this.post("up/configmap/update", params).then(function(d){
        if (complate_func && typeof(complate_func) == 'function'){
          complate_func();
        }
      }).done(function(){

      });
    }else{
      alert("标红的配置项有格式错误，请修改后再试！");
    }

    this.up_config_check_edit();
  };


  app.prototype.configmap_update = function(){
    var that = this;

    this.do_configmap_edit(null, function(){
      that.go("/up/database");
    });
  };


  app.prototype.setting_configmap = function(){
    var that = this;
    var jqRedeploy = $('#chk_redeploy');
    var redeploy = jqRedeploy.is(':checked');

    this.do_configmap_edit({"redeploy": redeploy}, function(){
      that.go("/setting/configmap")
    });
  };


  app.prototype.database_update = function(){
    var that = this;
    var count = 0, error = 0;

    if($("#btnDatabaseUpdate").attr('disabled') == "disabled"){
      return false;
    }

    $('#btnDatabaseUpdate').attr("disabled", true);
    jqProject = $('.upgrade-sql-list');

    // window.setTimeout(function() {
    jqProject.each(function(idx, item){
      var me = $(item);
      var project = me.data('project');
    
      that.post("up/database/update", {'project': project}).then(function(d){
        count = count + 1;

        if (d.content.errorSeq != -1){
          error = error + 1;

          id = "dvProject_" + d.content.project + "_update_" + d.content.errorSeq;
          $("#" + id).addClass("update-error");
        }

        if (count == jqProject.length && error == 0){
          that.go("/up/service");
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
    var hasErr = false;

    if($("#btnConfigmapCreate").attr('disabled') == "disabled"){
      return false;
    }

    $('#btnConfigmapCreate').attr("disabled","disabled");

    $('.config-review textarea').each(function(idx, item){
      var me = $(item);
      var key = me.data('key');
      var mapFormat = me.data('format');

      var val = me.val();
      var formatErr = !that.config_format(val, mapFormat);

      me.parents('.config-item-group').removeClass('error');
      if (!formatErr){
        maps[key] = val;
      }else{
        me.parents('.config-item-group').addClass('error');
        hasErr = true;
      }
    });

    if(!hasErr){
      this.post("up/configmap/create", maps).then(function(d){
        that.go("/up/configmap");
      }).done(function(){
        that.config_item_checked_all();
      });
    }else{
      alert("标红的配置项有格式错误，请修改后再试！");
    }
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

    if($("#settingModalButtonOK").attr('disabled') == "disabled"){
      return false;
    }

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

  app.prototype.sync_integration = function(){
    this.post('setting/sync_integration').done(function(d){

    });
  };

  app.prototype.sync_pipeline = function(){
    this.post('setting/sync_pipeline').done(function(d){

    });
  };

  app.prototype.sync_field_list = function(){
    this.post('setting/sync_field_list').done(function(d){

    });
  };

  app.prototype.tls_change_model = function(){
    var that = this;
    var jqPrivateKey = $('#iptCertificatePrivateKey'),
        jqContent = $("#iptCertificateContent");

    var params = {
      "key": "other",
      "format": "json"
    };

    if($("#btnTLSModalButtonOK").attr('disabled') == "disabled"){
      return false;
    }

    $("#btnTLSModalButtonOK").attr('disabled', true);

    var validateFunc = function(){
      var noNone =  $.trim(jqPrivateKey.val()) != '' &&
                    $.trim(jqContent.val()) != '';

      $("#btnTLSModalButtonOK").attr('disabled', !noNone);
    }

    this.get('setting/get', params).done(function(d){
      $("#TLSModel").modal("show");

      var vTLS = d.content.tls || {}

      jqPrivateKey.val(vTLS.certificatePrivateKey || '');
      jqContent.val(vTLS.certificateContent || '');

      validateFunc();
    });

    var jqMerged = jqPrivateKey.add(jqContent);
    jqMerged.on('keyup', function(){
      validateFunc();
    });
  };

  app.prototype.do_tls_change = function(){
    var jqPrivateKey = $('#iptCertificatePrivateKey'),
        jqContent = $("#iptCertificateContent");

    var params = {
      "certificatePrivateKey": jqPrivateKey.val(),
      "certificateContent": jqContent.val()
    }

    this.post('setting/tls/change', params).done(function(d){
      content = d.content
      if(content.success){
        $("#TLSModel").modal("hide");
      }
    });

  };

  app.prototype.activate_license = function(){
    var that = this;
    var jqAK = $("#iptGuanceAK"), 
        jqSK = $("#iptGuanceSK"),
        jqDataWayUrl = $("#iptDialDataWay"),
        jqLicense = $("#iptLicense");

    var params = {
      "key": "other",
      "format": "json"
    };

    if($("#activateModalButtonOK").attr('disabled') == "disabled"){
      return false;
    }

    $("#activateModalButtonOK").attr('disabled', true);

    var validateFunc = function(){
      var noNone =  $.trim(jqAK.val()) != '' && 
                    $.trim(jqSK.val()) != '' && 
                    $.trim(jqDataWayUrl.val()) != '' &&
                    $.trim(jqLicense.val()) != '';

      $("#activateModalButtonOK").attr('disabled', !noNone);
    }

    this.get('setting/get', params).done(function(d){
      $("#licenseModel").modal("show");

      var vGuance = d.content.guance || {}

      jqAK.val(vGuance.ak);
      jqSK.val(vGuance.sk);
      jqDataWayUrl.val(vGuance.dataway_url);
      jqLicense.val(vGuance.license);

      validateFunc();
    });

    var jqMerged = jqAK.add(jqSK).add(jqDataWayUrl).add(jqLicense);
    jqMerged.on('keyup', function(){
      validateFunc();
    });
  };

  app.prototype.do_activate = function(){
    var jqAK = $("#iptGuanceAK"), 
        jqSK = $("#iptGuanceSK"),
        jqDataWayUrl = $("#iptDialDataWay"),
        jqLicense = $("#iptLicense");

    var params = {
      "ak": $.trim(jqAK.val()),
      "sk": $.trim(jqSK.val()),
      "dataway_url": $.trim(jqDataWayUrl.val()),
      "license": $.trim(jqLicense.val())
    }

    this.post('setting/activate', params).done(function(d){
      content = d.content
      if(content.success){
        $("#licenseModel").modal("hide");
      } else {
        alert({
              'kodo.licenseNotFound': '无效的 License', 
              'kodo.licenseCommitIdNotMatch': '无效的 License', 
              'kodo.invalidLicense': '无效的 License', 
              'kodo.licenseExpire': 'License 已过期',
              'invaildLicense': '无效的 License'
            }[content.result] || "激活失败！")
      }
      console.log(d);
    });
  };

  app.prototype.mysql_install = function(){
    var mysql_password = $("#mysql_password").val();
    if (mysql_password === "") {
      alert("请输入MySQL密码");
      return
    }

    var params = {
      'mysql_password': btoa(mysql_password),
      'storage_class': $("#storage_class").val()
    };
    this.post('mysql/install', params).done(function(response){
      if (!response.success) {
        alert(`安装失败\n${response.message}`);
      } else {
        console.debug(response);
        $("#iptDBHost").val("mysql.middleware.svc.cluster.local");
        $("#iptDBPort").val("3306");
        $("#iptDBUserName").val("root");
        $("#iptDBUserPwd").val($("#mysql_password").val());
        alert("安装成功");
      }
    });
  };

  app.prototype.redis_install = function(){
    var redis_password = $("#redis_password").val();
    if (redis_password === "") {
      alert("请输入Redis密码");
      return
    }

    var params = {
      'redis_password': btoa(redis_password),
      'storage_class': $("#storage_class").val()
    };
    this.post('redis/install', params).done(function(response){
      if (!response.success) {
        alert(`安装失败\n${response.message}`);
      } else {
        console.debug(response);
        $("#iptRedisHost").val("redis.middleware.svc.cluster.local");
        $("#iptRedisPort").val("6379");
        $("#iptRedisPassword").val($("#redis_password").val());
        alert("安装成功");
      }
    });
  }

  app.prototype.opensearch_install = function(){
    var params = {'storage_class': $("#storage_class").val()};
    this.post('opensearch/install', params).done(function(response){
      if (!response.success) {
        alert(`安装失败\n${response.message}`);
      } else {
        console.debug(response);
        $("#iptESHost").val("opensearch-single.middleware.svc.cluster.local");
        $("#ckbElasticsearchSSL").prop("checked", false)
        $("#iptESPort").val("9200");
        $("#iptESUserName").val("admin");
        $("#iptESUserPwd").val("admin");
        $("#sltESProvider").val("opensearch");
        alert("安装成功");
      }
    });
  }

  app.prototype.tdengine_install = function(){
    var params = {'storage_class': $("#storage_class").val()};
    this.post('tdengine/install', params).done(function(response){
      if (!response.success) {
        alert(`安装失败\n${response.message}`);
      } else {
        console.debug(response);
        $("input:radio[value='influxdb']").prop("checked", false)
        $("input:radio[value='tdengine']").prop("checked", true)
        $("#timeseries-tdengine").prop("checked", true)
        $("#iptInfluxDBHost1").val("tdengine.middleware.svc.cluster.local");
        $("#ckbInfluxDBSSL1").prop("checked", false)
        $("#iptInfluxDBPort1").val("6041");
        $("#iptInfluxDBUserName1").val("root");
        $("#iptInfluxDBPassword1").val("taosdata");
        alert("安装成功");
      }
    });
  }

  app.prototype.external_dataway_install = function() {
    var params = {
      'name': $("#dataway-name").val(),
      'cluster_node': $("#cluster_node").val()
    };

    this.post('external_dataway/install', params).done(function(response){
      if (!response.success) {
        alert(`安装失败\n${response.message}`);
      } else {
        console.debug(response);
        alert("安装成功");
      }
    });  
  }

  app.prototype.on_cluster_node_change = function() {
    var cluster_node = $("#cluster_node").val();
    $("#external-dataway-url").text(`http://${cluster_node}:32528`);
  }

  return new app();
})();
