Rex 中文翻译
==============

### 这个是翻译rexify.org 网站的中文版

*   发布在 <http://rex.perl-china.com> 网站
*   如果你想加入我们请联系 <rao.chenlin@gmail.com>
*   QQ群 252744726

### 当前进度

* 目前主要欠缺 html/templates/howtos/ 下的文章没有翻译。
* 搜索对中文有问题，title 目前显示是乱码。


部署说明
==============

### 部署

直接 `morbo website.pl` 即可

### 搜索

采用 ElasticSearch 支持搜索，需要启用 elasticsearch-mapper-attachments 插件来完成具体内容的解析和高亮。

    rpm -ivh https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.3.noarch.rpm
    /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/1.9.0

然后运行 `create_index.pl localhost 9200 html/templates` 脚本重建索引即可。

如果没有插件，搜索也会正常返回结果，但只有 title 和 fs 两列，因为 file 列变成了 base64 编码解析不出来，也就没法搜索和返回高亮词条了。
