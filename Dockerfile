FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim-arm64v8

ARG RIDER_VERSION=2022.2

WORKDIR /app

RUN mkdir -p /root/.local/share/JetBrains/RiderRemoteDebugger \ 
    && apt-get update \
    && apt-get install -y unzip curl procps \    
    && curl -fsSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l ~/vsdbg \
    && curl -fsSL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt install -y nodejs \
    && npm install -g nodemon rimraf concurrently \    
    && curl -fsSL https://download.jetbrains.com/rider/ssh-remote-debugging/linux-arm64/jetbrains_debugger_agent_20210604.19.0 -o /root/.local/share/JetBrains/DebuggerAgent \
    && curl -fsSL https://download.jetbrains.com/resharper/dotUltimate.${RIDER_VERSION}/JetBrains.Rider.RemoteDebuggerUploads.linux-arm64.${RIDER_VERSION}.zip -o /root/.local/share/JetBrains/RiderRemoteDebugger/JetBrains.Rider.RemoteDebuggerUploads.linux-arm64.${RIDER_VERSION}.zip \
    && unzip -o /root/.local/share/JetBrains/RiderRemoteDebugger/JetBrains.Rider.RemoteDebuggerUploads.linux-arm64.${RIDER_VERSION}.zip -d /root/.local/share/JetBrains/RiderRemoteDebugger/${RIDER_VERSION} \ 
    && chmod +x /root/.local/share/JetBrains/DebuggerAgent

ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 80 5255

CMD ["concurrently", "/root/.local/share/JetBrains/DebuggerAgent -port=5255", "dotnet WebApplication1DockerRemoteDebugging.dll"]