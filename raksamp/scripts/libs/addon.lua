-- player_pool = {}

function sendSpawnRequest()
    bitStream.new():sendRPC(129)
end

function sendDialogResponse(id, button, list, input)
    print("send dialog response:", id, button, list, input)
    local bs = bitStream.new()
    bs:writeUInt16(id)
    bs:writeUInt8(button)
    bs:writeUInt16(list)
    bs:writeUInt8(input:len())
    bs:writeString(input)
    bs:sendRPC(62)
end

function sendPickedUpPickup(id)
    assert(id and type(id) == "number", "number expected, got "..type(id))

    local bs = bitStream.new()
    bs:writeUInt32(id)
    bs:sendRPC(131)
end

function sendClickTextdraw(id)
    assert(id and type(id) == "number", "number expected, got "..type(id))
    local bs = bitStream.new()
    bs:writeUInt16(id)
    bs:sendRPC(83)
end

function sendInput(text)
    assert(text and type(text) == "string", "string expected, got "..type(text))
    local bs = bitStream.new()
    if text:sub(1, 1) == "/" then
        bs:writeUInt32(text:len())
        bs:writeString(text)
        bs:sendRPC(50)
    else
        bs:writeUInt8(text:len())
        bs:writeString(text)
        bs:sendRPC(101)
    end
end

function bitStream:readString8()
	return self:readString(self:readUInt8())
end

function bitStream:readBool8()
    return (self:readUInt8() ~= 0)
end

registerHandler("onReceiveRPC", function(id, bs)
    -- if id == RPC_SCRSERVERJOIN then
    --     local player_id = bs:readUInt16()
    --     local color = bs:readUInt32()
    --     local is_npc = bs:readBool8()
    --     local nick = bs:readString8()
    --     player_pool[player_id] = nick

    -- elseif id == RPC_SCRSERVERQUIT then
    --     local player_id = bs:readUInt16()
    --     local reason = bs:readUInt8()
    --     player_pool[player_id] = nil

    -- elseif id == RPC_SCRSETPLAYERNAME then
    --     local player_id = bs:readUInt16()
    --     local nick = bs:readString8()
    --     if bs:readBool8() then
    --         player_pool[player_id] = nick
    --     end

    -- end
end)

registerHandler("onRunCommand", function(cmd)
    if cmd == "!ppool" then
        for k, v in pairs(player_pool) do
            print(k, v)
        end
        return false
    end
end)