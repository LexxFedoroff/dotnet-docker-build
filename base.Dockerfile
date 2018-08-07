FROM microsoft/dotnet:sdk

RUN apt-get update && \
    apt-get install unzip

# Install NodeJS...
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

# Install Cake...
RUN wget https://www.nuget.org/api/v2/package/Cake.CoreCLR/0.29.0 -O cake.zip && \
    unzip cake.zip -d /usr/share/cake && \ 
    rm cake.zip && \
    echo "dotnet /usr/share/cake/Cake.dll \"\$@\"" > /usr/bin/cake && \
    chmod +x /usr/bin/cake