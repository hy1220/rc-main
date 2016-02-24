meeters = {}
writers={}
function onConnection(client)

  --if (client.protocol == "RTMFP") then
    INFO(" address: ", client.address)
    client.name = client
    meeters[client] = client
	
 -- else
    INFO("Connection from client ", client.protocol)

  function client:onIdentification(name)
		INFO(name," and ",meeters[client])
		
		client.name = name
		writers[name] = client
		
		peer = meeters[client]
		local localUser=client.name
		if peer then
			INFO("Trying to connect user : ", name)
			-- Send all current users
			for peer in pairs(meeters) do
				--client.writer:writeInvocation("onEvent", "connection", peerName)
				 INFO("Founded!")
				peer.writer:writeInvocation("onEvent","connection",name)
			end
		end
	
	  --if (client.protocol == "RTMFP") then
		INFO("User connected:  address: ", meeters[client] )
	 -- else
		INFO("Connection from client ", client.protocol)
	end
	
  function client:sendCommand(command,name)

      INFO("sendCommand to ", name, "...",meeters[client])
      peer = writers[name]
      local localUser=client.name
      if peer then
        INFO("Founded!")
        peer.writer:writeInvocation("onSendCommand",command,localUser)
        --return peer.id
      else
        error("User "..name.." not founded!")
      end
    end

  function client:callUser(name,action)
  
    INFO("Trying to call ", name, "...")
    peer = writers[name]
    local localUser=client.name
    if peer then
		INFO("Trying to call user : ", name)
		-- Send all current users
		--for peer in pairs(meeters) do
			--client.writer:writeInvocation("onEvent", "connection", peerName)
			INFO("Founded!")
			peer.writer:writeInvocation("onRelay",action,localUser)
		--end
	end
  end
  
 function client:sendMsg(name,msg)
  
    INFO("Trying to call ", name, "...")
    peer = writers[name]
    local localUser=client.name
    if peer then
      INFO("Founded!")
      peer.writer:writeInvocation("showMsg",localUser,msg)
      --return peer.id
    else
      error("User "..name.." not founded!")
    end
  end

  return {index="VideoPhone.html"}
end
