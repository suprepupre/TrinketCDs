if not CreateFramePool then
    local tinsert, tremove = table.insert, table.remove

    local function NewPool(createFunc, resetter)
        local pool = { inactive = {}, active = {} }

        function pool:Acquire()
            local obj = tremove(self.inactive)
            local isNew = false
            if not obj then
                obj = createFunc()
                isNew = true
            end
            self.active[obj] = true
            return obj, isNew
        end

        function pool:Release(obj)
            if not obj then return end
            if self.active[obj] then
                self.active[obj] = nil
            end
            if resetter then
                resetter(self, obj)
            end
            tinsert(self.inactive, obj)
        end

        return pool
    end

    function CreateTexturePool(parent, layer, subLayer, resetter)
        local function create()
            local tex = parent:CreateTexture(nil, layer)
            if tex.SetDrawLayer then
                tex:SetDrawLayer(layer, subLayer or 0)
            end
            return tex
        end
        return NewPool(create, resetter)
    end

    function CreateFramePool(frameType, parent, template, resetter)
        local function create()
            if template == "" then template = nil end
            return CreateFrame(frameType, nil, parent, template)
        end
        return NewPool(create, resetter)
    end
end

if not CreateTexturePool then
    local tinsert, tremove = table.insert, table.remove

    local function NewPool(createFunc, resetter)
        local pool = { inactive = {}, active = {} }

        function pool:Acquire()
            local obj = tremove(self.inactive)
            local isNew = false
            if not obj then
                obj = createFunc()
                isNew = true
            end
            self.active[obj] = true
            return obj, isNew
        end

        function pool:Release(obj)
            if not obj then return end
            if self.active[obj] then
                self.active[obj] = nil
            end
            if resetter then
                resetter(self, obj)
            end
            tinsert(self.inactive, obj)
        end

        return pool
    end

    function CreateTexturePool(parent, layer, subLayer, resetter)
        local function create()
            local tex = parent:CreateTexture(nil, layer)
            if tex.SetDrawLayer then
                tex:SetDrawLayer(layer, subLayer or 0)
            end
            return tex
        end
        return NewPool(create, resetter)
    end
end