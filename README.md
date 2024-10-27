# How do I do it?

Spawn a `blade_saw` - Use `blade_saw` to equip it - Whilst holding `blade_saw` go to a sign & if it's a listed sign in your Config.Signs table, then you'll 
be prompted to `Hold [E] to cut down sign`

After cutting down a sign, it will disappear for everyone and if you use said sign from your inventory, you'll be able to hold it to show off

As player load into the server, it'll grab the `removedSigns` table from the server and remove any signs, at the stored coords that have been removed. Ensuring synced sign removals for all players

# Add items to items.lua
```
    ['blade_saw'] = {
        label = "Big Ole' Saw",
        weight = 3500,
        stack = false,
        close = true,
        client = {
            event = 'signrobbery:client:EquipBladeSaw'
        },
    },

    ['stopsign'] = {
        label = 'Stop Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_01a',
        },
    },

    ['walkingmansign'] = {
        label = 'Walking Man Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_05a',
        },
    },

    ['dontblockintersectionsign'] = {
        label = 'Intersection Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_03e',
        },
    },

    ['uturnsign'] = {
        label = 'U-Turn Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_03m',
        },
    },

    ['noparkingsign'] = {
        label = 'No Parking Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_04a',
        },
    },

    ['leftturnsign'] = {
        label = 'Left Turn Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_05e',
        },
    },

    ['rightturnsign'] = {
        label = 'Right Turn Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_05f',
        },
    },

    ['notrespassingsign'] = {
        label = 'Trespassing Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_restriction_10',
        },
    },

    ['yieldsign'] = {
        label = 'Yield Sign',
        weight = 297,
        stack = true,
        close = true,
        client = {
            event = 'signrobbery:client:DisplaySign',
            model = 'prop_sign_road_02a',
        },
    },
```

# Add images from images file
