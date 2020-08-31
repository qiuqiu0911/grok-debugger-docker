FROM centos:7
RUN yum -y install openssl-devel gcc make unzip
ENV PATH=/usr/local/sbin:/usr/local/bin;/usr/sbin;/usr/bin:/sbin:/bin:/usr/local/ruby2.1.7/bin:/usr/local/rubygems-2.6.2/bin/
#install ruby 2.1.7 https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.7.tar.gz
COPY ruby-2.1.7.tar.gz /
RUN tar -xzvf /ruby-2.1.7.tar.gz && cd ruby-2.1.7 && ./configure --prefix=/usr/local/ruby2.1.7
RUN cd ruby-2.1.7 && make && make install
RUN rm -rf /ruby-2.1.7.tar.gz /ruby-2.1.7
# install rubygems-2.6.2 https://rubygems.org/rubygems/rubygems-2.6.2.tgz
COPY rubygems-2.6.2.tgz /
RUN mkdir /usr/local/rubygems-2.6.2/ && tar -zxvf rubygems-2.6.2.tgz -C /usr/local/rubygems-2.6.2/ \
&& cd /usr/local/rubygems-2.6.2/rubygems-2.6.2 && ruby setup.rb 
RUN gem sources --remove https://rubygems.org/ && gem sources --add https://gems.ruby-china.com/
RUN rm -f /rubygems-2.6.2.tgz
# install grokdebugger https://codeload.github.com/robinlennox/grokdebug/zip/master
COPY grokdebug-master.zip /
RUN mkdir /usr/local/grokdebug-master. && unzip /grokdebug-master.zip -d /usr/local
RUN gem install bundler -v 1.17.3 && gem install cabin -v 0.5.0 && gem install haml -v 3.1.7 \
&& gem install jls-grok -v 0.10.10 && gem install json -v 1.7.5 && gem install kgio -v 2.8.0 \
&& gem install rack -v 1.4.1 && gem install rack-protection -v 1.2.0 && gem install raindrops -v 0.11.0 \
&& gem install shotgun -v 0.9 && gem install tilt -v 1.3.3 && gem install sinatra -v 1.3.3 \
&& gem install unicorn -v 4.6.3
RUN rm -f /grokdebug-master.zip
EXPOSE 9999
ENTRYPOINT cd /usr/local/grokdebug-master && bundle exec unicorn -p 9999 -c ./unicorn
LABEL maintainer="qiu_zs@126.com"