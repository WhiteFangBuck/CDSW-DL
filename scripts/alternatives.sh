#!/bin/bash
# Provided and modified from example blog: http://bad-concurrency.blogspot.com/2014/01/linux-alternatives-and-oracle-java.html
#Change JAVA_HOME
LINKDIR=/usr/bin
JAVA_HOME=/usr/java/latest
JREDIR=$JAVA_HOME/jre/bin
JDKDIR=$JAVA_HOME/bin


alternatives --install $LINKDIR/java java $JREDIR/java 20000  \
  --slave $LINKDIR/keytool     keytool     $JREDIR/keytool         \
  --slave $LINKDIR/orbd        orbd        $JREDIR/orbd            \
  --slave $LINKDIR/pack200     pack200     $JREDIR/pack200         \
  --slave $LINKDIR/rmid        rmid        $JREDIR/rmid            \
  --slave $LINKDIR/rmiregistry rmiregistry $JREDIR/rmiregistry     \
  --slave $LINKDIR/servertool  servertool  $JREDIR/servertool      \
  --slave $LINKDIR/tnameserv   tnameserv   $JREDIR/tnameserv       \
  --slave $LINKDIR/unpack200   unpack200   $JREDIR/unpack200       \
  --slave $LINKDIR/jcontrol    jcontrol    $JREDIR/jcontrol        \
  --slave $LINKDIR/javaws      javaws      $JREDIR/javaws

alternatives --install $LINKDIR/javac javac $JDKDIR/javac 20000  \
  --slave $LINKDIR/appletviewer appletviewer $JDKDIR/appletviewer     \
  --slave $LINKDIR/apt          apt          $JDKDIR/apt              \
  --slave $LINKDIR/extcheck     extcheck     $JDKDIR/extcheck         \
  --slave $LINKDIR/idlj         idlj         $JDKDIR/idlj             \
  --slave $LINKDIR/jar          jar          $JDKDIR/jar              \
  --slave $LINKDIR/jarsigner    jarsigner    $JDKDIR/jarsigner        \
  --slave $LINKDIR/javadoc      javadoc      $JDKDIR/javadoc          \
  --slave $LINKDIR/javah        javah        $JDKDIR/javah            \
  --slave $LINKDIR/javap        javap        $JDKDIR/javap            \
  --slave $LINKDIR/jcmd         jcmd         $JDKDIR/jcmd             \
  --slave $LINKDIR/jconsole     jconsole     $JDKDIR/jconsole         \
  --slave $LINKDIR/jdb          jdb          $JDKDIR/jdb              \
  --slave $LINKDIR/jhat         jhat         $JDKDIR/jhat             \
  --slave $LINKDIR/jinfo        jinfo        $JDKDIR/jinfo            \
  --slave $LINKDIR/jmap         jmap         $JDKDIR/jmap             \
  --slave $LINKDIR/jps          jps          $JDKDIR/jps              \
  --slave $LINKDIR/jrunscript   jrunscript   $JDKDIR/jrunscript       \
  --slave $LINKDIR/jsadebugd    jsadebugd    $JDKDIR/jsadebugd        \
  --slave $LINKDIR/jstack       jstack       $JDKDIR/jstack           \
  --slave $LINKDIR/jstat        jstat        $JDKDIR/jstat            \
  --slave $LINKDIR/jstatd       jstatd       $JDKDIR/jstatd           \
  --slave $LINKDIR/native2ascii native2ascii $JDKDIR/native2ascii     \
  --slave $LINKDIR/policytool   policytool   $JDKDIR/policytool       \
  --slave $LINKDIR/rmic         rmic         $JDKDIR/rmic             \
  --slave $LINKDIR/schemagen    schemagen    $JDKDIR/schemagen        \
  --slave $LINKDIR/serialver    serialver    $JDKDIR/serialver        \
  --slave $LINKDIR/wsgen        wsgen        $JDKDIR/wsgen            \
  --slave $LINKDIR/wsimport     wsimport     $JDKDIR/wsimport         \
  --slave $LINKDIR/xjc          xjc          $JDKDIR/xjc
