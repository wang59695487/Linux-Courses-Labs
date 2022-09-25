#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <time.h>
#include <pwd.h>
#include <grp.h>
void print(struct stat *st){
   switch (st->st_mode & S_IFMT) {
       case S_IFBLK: printf("b"); break; //块设备文件
       case S_IFCHR: printf("c"); break; //字符设备文件
       case S_IFDIR: printf("d"); break; //目录文件
       case S_IFIFO: printf("p"); break; //管道文件
       case S_IFLNK: printf("l"); break; //符号链接文件
       case S_IFSOCK: printf("s\n"); break; //socket
       default: printf("-"); break; //普通文件
   }
   if (st->st_mode & S_IRUSR) printf("r"); //文件所有者具可读取权限
   else printf("-");
   if (st->st_mode & S_IWUSR) printf("w"); //文件所有者具可写入权限
   else printf("-");
   if (st->st_mode & S_IXUSR) printf("x"); //文件所有者具可执行权限
   else printf("-");
   if (st->st_mode & S_IRGRP) printf("r"); //所有者所在的用户组具可读取权限
   else printf("-");
   if (st->st_mode & S_IWGRP) printf("w"); //所有者所在的用户组具可写入权限
   else printf("-");

   if (st->st_mode & S_IXGRP) printf("x"); //所有者所在的用户组具可执行权限
   else printf("-");
   if (st->st_mode & S_IROTH) printf("r"); //其他用户组具可读取权限
   else printf("-");
   if (st->st_mode & S_IWOTH) printf("w"); //其他用户组具可写入权限
   else printf("-");
   if (st->st_mode & S_IXOTH) printf("x"); //其他用户组具可执行权限
   else printf("-");

   printf(" %3ld ", (long)st->st_nlink); //链接数
   struct passwd *pwd = getpwuid(st->st_uid); //用户名
   printf(" %6s ", pwd->pw_name);
   struct group *grp = getgrgid(st->st_gid); //组名
   printf(" %6s ", grp->gr_name);
   printf(" %6ld ", (long)st->st_size); //大小
   printf(" %s", ctime(&st->st_mtime)); //最后修改时间
}

int main(int argc, char* argv[]){
      DIR *dir;
      struct dirent *item;
      struct stat buf;
      int i,count=0;
      dir = opendir("./");//打开当前目录并建立一个目录流
      if(strcmp(argv[1],"ls")!= 0) {//如果输入参数不是 ls
            printf("cannot recognize the command!\n");
            return 1;
      }
      //no option
      if(argc == 2){ // 如果输入参数仅有一个 ls
          item = readdir(dir);count++;
      while(item != NULL){
         //去除文件.和..
          if(strcmp(item->d_name,".")==0 || strcmp(item->d_name,"..")==0 ){
              item = readdir(dir);
              continue;
          }//左对齐占用 10 格的形式输出文件名
          printf("%-10s ",item->d_name);count++;
          if(count%5 == 1) printf("\n");//一行输出 5 个
          item = readdir(dir); //获取下一个文件
      }
         printf("\n");
      }
      // with option
      if(argc == 3){
           // -a 与无参数 ls 类似，但是要输出.和..文件
          if(strcmp(argv[2],"-a") == 0){
              item = readdir(dir);count++;
              while(item != NULL){
                   printf("%-10s ",item->d_name);
                   count++;
                   if(count%5 == 1) printf("\n");
                   item = readdir(dir); //获取下一个文件
              }
              printf("\n");
          }
          // -i
          if(strcmp(argv[2],"-i") == 0){
                item = readdir(dir);count++;
                while(item != NULL){
                     if(strcmp(item->d_name,".")==0 ||strcmp(item->d_name,"..")==0 ){
                         item = readdir(dir);
                         continue;
                     }
                     //输出 inode 以及文件名
                     printf("%ld %-10s ",item->d_ino,item->d_name);
                     count++;
                     if(count%4 == 1) printf("\n");
                     item = readdir(dir); //获取下一个文件
                }
                printf("\n");
          }
          // -l
          if(strcmp(argv[2],"-l") == 0){
                item = readdir(dir);
                while(item != NULL){
                    if(strcmp(item->d_name,".")==0 || strcmp(item->d_name,"..")==0 ){
                        item = readdir(dir);//读取下一个，不进行 print
                        continue;
                    }
                    lstat(item->d_name,&buf);//通过文件名查找文件的信息
                    printf(" %-10s ",item->d_name);//先打印文件名
                    print(&buf);//调用自定义的打印函数，依次打印文件的信息
                    item = readdir(dir);//获取下一个文件
                    }
          }
      }
}
