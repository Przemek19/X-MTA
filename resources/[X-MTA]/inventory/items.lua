DEFAULT_WEIGHT = 0
DEFAULT_MAX_IN_STACK = 1
ITEMS_IMAGES_DIR = "images/items/"
INVENTORY_SIZE = {5, 4}
SLOT_SIZE = 88 -- PX
SLOTS_MARGIN = 4 -- PX
SLOT_PADDING = 8 -- PX
DROP_NAME = "Wyrzuć"

WINDOW_COLOR = tocolor(12, 12, 13, 180)
SLOT_COLOR = tocolor(42, 44, 46, 200)

ITEMS_POSITIONS = {}

TEX = {
  "nil",
  "water",
  "car_key",
}

local function loadTextures()
  local tmpTEX = {}
  for i, v in pairs(TEX) do
    tmpTEX[v] = dxCreateTexture(ITEMS_IMAGES_DIR .. v .. ".png")
  end
  TEX = tmpTEX
  tmpTEX = nil
end

coroutine.resume(coroutine.create(loadTextures))
loadTextures = nil

items = {
  {
    --id = ID PRZEDMIOTU,
    --name = NAZWA PRZEDMIOTU,
    --img = TEKSTURA
    --description = OPIS PRZEDMIOTU
    --weight = WAGA PRZEDMIOTU,
    --maxInStack = MAKSYMALNA ILOŚĆ PRZEDMIOTÓW W STACKU,
    --expandable = CZY PRZEDMIOT JEST ZUŻYWALNY CZY NIE true/nil,
  },
  {
    id = 1,
    name = "Woda 0,5l",
    img = "water",
    description = "Półlitrowa, czysta woda.",
    weight = 0.5,
    maxInStack = 2,
    expandable = true,
    category = "Jedzenie",
    actions = {"Wypij", "Wylej"},
  },

  {
    id = 2,
    name = "Nic",
    description = "Całe nic",
  },

  {
    id = 3,
    name = "Klucze do pojazdu",
    img = "car_key",
    description = "Klucze do pojazdu o ID ||SUBTYPE||.",
    weight = 0.05,
    maxInStack = 2,
    actions = {"Otwórz pojazd", "Zamknij pojazd"},
  },
}

for i, v in pairs(items) do
  v.img = v.img or "nil"
  v.weight = v.weight or DEFAULT_WEIGHT
  v.maxInStack = v.maxInStack or DEFAULT_MAX_IN_STACK
  v.name = v.name or "BRAK NAZWY"
  v.description = v.description or "BRAK OPISU"
  if not v.actions then
    v.actions = {}
  end
  v.actions[#v.actions + 1] = DROP_NAME
  v.category = v.category or "Brak kategorii"
end