local lapis = require("lapis")
local app = lapis.Application()
local json = require("lunajson")
local open = io.open

local function read_file(path)
  local file = open(path, "r")
  if not file then return nil end
  local content = file:read "*a"
  file:close()
  return content
end

local function write_file(path, text)
  local file = open(path, "w")
  if not file then return nil end
  local content = file:write(text)
  file:close()
end

local function createItem(database, name, size, price)
  local file = read_file(database)
  local set = json.decode(file)
  local id = set[1].counter+1
  set[1].counter = id
  local item = {["id"] = id, ["name"] = name, ["size"] = size, ["price"] = price}
  table.insert(set, item)
  write_file(database, json.encode(set))
  print(json.encode(set))
  return item
end

local function findItem(database, id)
  local file = read_file(database)
  local set = json.decode(file)
  table.remove(set,1)
  local found = {["message"] = "no item with this id"}
  for i=1,#set do
    if set[i].id == id then
      found = set[i]
    end
  end
  return found
end

local function updateItem(database, category, id, value)
  local file = read_file(database)
  local set = json.decode(file)
  local found = {["message"] = "no item with this id"}
  for i=2,#set do
    if set[i].id == id then
      set[i][category] = value
      found = set[i]
      write_file(database, json.encode(set))
    end
  end
  return found
end

local function deleteItem(database, id)
  local file = read_file(database)
  local set = json.decode(file)
  local found = {["message"] = "no item with this id"}
  for i=2,#set do
    if set[i].id == id then
      table.remove(set, i)
      print(json.encode(set[i]))
      found = {["message"] = "deleted item with id: "..tostring(id)}
      write_file(database, json.encode(set))
      return found
    end
  end
end

app:get("/", function()
  local file1 = read_file("shirts.json")
  local set1 = json.decode(file1)
  table.remove(set1,1)
  local file2 = read_file("jumpers.json")
  local set2 = json.decode(file2)
  table.remove(set2,1)
  local file3 = read_file("trousers.json")
  local set3 = json.decode(file3)
  table.remove(set3,1)
  return {
    json = {
      info = "Welcome to simple REST API of a clothing store",
      categories = "shirts | jumpers | trousers",
      set1,
      set2,
      set3
    }
  }
end)

app:get("/shirts", function()
  local file = read_file("shirts.json")
  local set = json.decode(file)
  table.remove(set,1)
  return {
    json = {
      set
    }
  }
end)

app:get("/shirts/:id", function(self)
  return {
    json = {
      findItem("shirts.json", tonumber(self.params.id))
    }
  }
end)

app:get("/shirts/add/name/:name/size/:size/price/:price", function(self)
  return {
    json = {
      createItem("shirts.json", self.params.name, self.params.size, tonumber(self.params.price))
    }
  }
end)

app:get("/shirts/update/:id/name/:name", function(self)
  return {
    json = {
      updateItem("shirts.json", "name", tonumber(self.params.id), self.params.name)
    }
  }
end)

app:get("/shirts/update/:id/size/:size", function(self)
  return {
    json = {
      updateItem("shirts.json", "size", tonumber(self.params.id), self.params.size)
    }
  }
end)

app:get("/shirts/update/:id/price/:price", function(self)
  return {
    json = {
      updateItem("shirts.json", "price", tonumber(self.params.id), tonumber(self.params.price))
    }
  }
end)

app:get("/shirts/delete/:id", function(self)
  return {
    json = {
      deleteItem("shirts.json", tonumber(self.params.id))
    }
  }
end)

app:get("/jumpers", function()
  local file = read_file("jumpers.json")
  local set = json.decode(file)
  table.remove(set,1)
  return {
    json = {
      set
    }
  }
end)

app:get("/jumpers/:id", function(self)
  return {
    json = {
      findItem("jumpers.json", tonumber(self.params.id))
    }
  }
end)

app:get("/jumpers/add/name/:name/size/:size/price/:price", function(self)
  return {
    json = {
      createItem("jumpers.json", self.params.name, self.params.size, tonumber(self.params.price))
    }
  }
end)

app:get("/jumpers/update/:id/name/:name", function(self)
  return {
    json = {
      updateItem("jumpers.json", "name", tonumber(self.params.id), self.params.name)
    }
  }
end)

app:get("/jumpers/update/:id/size/:size", function(self)
  return {
    json = {
      updateItem("jumpers.json", "size", tonumber(self.params.id), self.params.size)
    }
  }
end)

app:get("/jumpers/update/:id/price/:price", function(self)
  return {
    json = {
      updateItem("jumpers.json", "price", tonumber(self.params.id), tonumber(self.params.price))
    }
  }
end)

app:get("/jumpers/delete/:id", function(self)
  return {
    json = {
      deleteItem("jumpers.json", tonumber(self.params.id))
    }
  }
end)

app:get("/trousers", function()
  local file = read_file("trousers.json")
  local set = json.decode(file)
  table.remove(set,1)
  return {
    json = {
      set
    }
  }
end)

app:get("/trousers/:id", function(self)
  return {
    json = {
      findItem("trousers.json", tonumber(self.params.id))
    }
  }
end)

app:get("/trousers/add/name/:name/size/:size/price/:price", function(self)
  return {
    json = {
      createItem("trousers.json", self.params.name, self.params.size, tonumber(self.params.price))
    }
  }
end)

app:get("/trousers/update/:id/name/:name", function(self)
  return {
    json = {
      updateItem("trousers.json", "name", tonumber(self.params.id), self.params.name)
    }
  }
end)

app:get("/trousers/update/:id/size/:size", function(self)
  return {
    json = {
      updateItem("trousers.json", "size", tonumber(self.params.id), self.params.size)
    }
  }
end)

app:get("/trousers/update/:id/price/:price", function(self)
  return {
    json = {
      updateItem("trousers.json", "price", tonumber(self.params.id), tonumber(self.params.price))
    }
  }
end)

app:get("/trousers/delete/:id", function(self)
  return {
    json = {
      deleteItem("trousers.json", tonumber(self.params.id))
    }
  }
end)

return app
