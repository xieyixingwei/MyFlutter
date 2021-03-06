import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/apps/github/common/Git.dart';
import 'package:helloworld/apps/github/models/index.dart';
import 'package:helloworld/apps/github/states/UserModel.dart';
import 'package:helloworld/apps/github/widgets/MyDrawer.dart';
import 'package:helloworld/apps/github/widgets/RepoItem.dart';
import 'package:provider/provider.dart';
import 'package:flukit/flukit.dart';


class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),///GmLocalizations.of(context).home),
      ),
      body: _buildBody(), // 构建主页面
      drawer: MyDrawer(), //抽屉菜单
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      //用户未登录，显示登录按钮
      return Center(
        child: RaisedButton(
          child: Text("Login"),///GmLocalizations.of(context).login),
          onPressed: () => Navigator.of(context).pushNamed("login"),
        ),
      );
    } else {
      //return Text("Home Page Login");
      //已登录，则展示项目列表
      return InfiniteListView<Repo>(
        onRetrieveData: (int page, List<Repo> items, bool refresh) async {
          try {
            var data = await Git(context).getRepos(
              refresh: refresh,
              queryParameters: {
                'page': page,
                'page_size': 20,
              },
            );
            print("getRepos success");
            //把请求到的新数据添加到items中
            items.addAll(data); 
            // 如果接口返回的数量等于'page_size'，则认为还有数据，反之则认为最后一页
            return data.length==20;
          } catch (e) {
            print("--- getRepos error");
            print(e.toString());
            return false;
          }
        },
        itemBuilder: (List list, int index, BuildContext ctx) {
          // 项目信息列表项
          return RepoItem(list[index]);
        },
      );
    }
  }
}
