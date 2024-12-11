//
//  StubObjects.swift
//  Pokeapi
//
//  Created by eli on 26/04/24.
//

import Foundation
import PokemonAPI
import Combine

enum MockObject {
    
    static let retryPokemonID = "RETRY"
    static func makeRetryPokemonViewModel(hasStopped: Bool) -> PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel.init(
            name: Self.retryPokemonID,
            id: Int.max,
            formattedID: Self.retryPokemonID,
            types: [Self.retryPokemonID, Self.retryPokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .retry(stop: hasStopped)
        )
    }

    static let loadMorePokemonID = "LOADING..."
    static var loadMorePokemonViewModel: PokemonCatalogItemViewModel {
        PokemonCatalogItemViewModel(
            name: Self.loadMorePokemonID,
            id: Int.max,
            formattedID: Self.loadMorePokemonID,
            types: [Self.loadMorePokemonID, Self.loadMorePokemonID],
            pokemonImageURL: nil,
            backgroundImageURL: nil,
            itemStyle: .load
        )
    }
    
    static var initalPaginationPokemonListData: Data? {
        return """
        {
            "count": 1302,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)
    }
    
    static var nextPagePokemonListData: Data? {
        return """
        {
            "count": 2,
            "next": null,
            "previous": "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1",
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)
    }
    
    static var nextPagePokemonList: PKMPagedObject<PKMPokemon> {
        return PKMPagedObject<PKMPokemon>.init(
            count: 2,
            next: "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
            previous: nil,
            current: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1",
            results: [],
            limit: 1,
            offset: 0
        )
    }
    
    static var lastPagePokemonListData: Data? {
        return """
        {
            "count": 2,
            "next": null,
            "previous": "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1",
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)
    }
    
    static var lastPagePokemonList: PKMPagedObject<PKMPokemon>? {
        return PKMPagedObject<PKMPokemon>.init(
            count: 2,
            next: nil,
            previous: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1",
            current: "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
            results: [],
            limit: 1,
            offset: 1
        )
    }
    
    static var emptyInitalPaginationPokemonListData: Data? {
        return """
        {
            "count": 1302,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)
    }
    
    static var nullInitalPaginationPokemonListData: Data? {
        return """
        {
            "count": 1302,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
            "previous": null
        }
        """.data(using: .utf8)
    }
    
    static var initalPaginationPokemonList: PKMPagedObject<PKMPokemon>? {
        guard let initalPaginationPokemonListData else {
            return nil
        }
        
        return try? PKMPagedObject<PKMPokemon>.decode(from: initalPaginationPokemonListData)
    }
    
    static var bulbasaurData: Data? {
        return  """
        {
            "abilities": [
                {
                    "ability": {
                        "name": "overgrow",
                        "url": "https://pokeapi.co/api/v2/ability/65/"
                    },
                    "is_hidden": false,
                    "slot": 1
                },
                {
                    "ability": {
                        "name": "chlorophyll",
                        "url": "https://pokeapi.co/api/v2/ability/34/"
                    },
                    "is_hidden": true,
                    "slot": 3
                }
            ],
            "base_experience": 64,
            "cries": {
                "latest": "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/1.ogg",
                "legacy": "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/1.ogg"
            },
            "forms": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon-form/1/"
                }
            ],
            "game_indices": [
                {
                    "game_index": 153,
                    "version": {
                        "name": "red",
                        "url": "https://pokeapi.co/api/v2/version/1/"
                    }
                },
                {
                    "game_index": 153,
                    "version": {
                        "name": "blue",
                        "url": "https://pokeapi.co/api/v2/version/2/"
                    }
                },
                {
                    "game_index": 153,
                    "version": {
                        "name": "yellow",
                        "url": "https://pokeapi.co/api/v2/version/3/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "gold",
                        "url": "https://pokeapi.co/api/v2/version/4/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "silver",
                        "url": "https://pokeapi.co/api/v2/version/5/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "crystal",
                        "url": "https://pokeapi.co/api/v2/version/6/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "ruby",
                        "url": "https://pokeapi.co/api/v2/version/7/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "sapphire",
                        "url": "https://pokeapi.co/api/v2/version/8/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "emerald",
                        "url": "https://pokeapi.co/api/v2/version/9/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "firered",
                        "url": "https://pokeapi.co/api/v2/version/10/"
                    }
                },
                {
                    "game_index": 1,
                    "version": {
                        "name": "leafgreen",
                        "url": "https://pokeapi.co/api/v2/version/11/"
                    }
                }
            ],
            "height": 7,
            "held_items": [],
            "id": 1,
            "is_default": true,
            "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/1/encounters",
            "moves": [
                    {
                        "move": {
                            "name": "razor-wind",
                            "url": "https://pokeapi.co/api/v2/move/13/"
                        },
                        "version_group_details": [
                            {
                                "level_learned_at": 0,
                                "move_learn_method": {
                                    "name": "egg",
                                    "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                                },
                                "version_group": {
                                    "name": "gold-silver",
                                    "url": "https://pokeapi.co/api/v2/version-group/3/"
                                }
                            },
                            {
                                "level_learned_at": 0,
                                "move_learn_method": {
                                    "name": "egg",
                                    "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                                },
                                "version_group": {
                                    "name": "crystal",
                                    "url": "https://pokeapi.co/api/v2/version-group/4/"
                                }
                            }
                        ]
                    }
            ],
            "name": "bulbasaur",
            "order": 1,
            "past_abilities": [],
            "past_types": [],
            "species": {
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
            },
            "sprites": {
                "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                "back_female": null,
                "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                "back_shiny_female": null,
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                "front_female": null,
                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png",
                "front_shiny_female": null,
                "other": {
                    "dream_world": {
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg",
                        "front_female": null
                    },
                    "home": {
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png",
                        "front_female": null,
                        "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png",
                        "front_shiny_female": null
                    },
                    "official-artwork": {
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                        "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/1.png"
                    },
                    "showdown": {
                        "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/1.gif",
                        "back_female": null,
                        "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/shiny/1.gif",
                        "back_shiny_female": null,
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/1.gif",
                        "front_female": null,
                        "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/shiny/1.gif",
                        "front_shiny_female": null
                    }
                },
                "versions": {
                    "generation-i": {
                        "red-blue": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/1.png",
                            "back_gray": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/gray/1.png",
                            "back_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/back/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/1.png",
                            "front_gray": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/gray/1.png",
                            "front_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/1.png"
                        },
                        "yellow": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/1.png",
                            "back_gray": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/gray/1.png",
                            "back_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/back/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/1.png",
                            "front_gray": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/gray/1.png",
                            "front_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/1.png"
                        }
                    },
                    "generation-ii": {
                        "crystal": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/1.png",
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/shiny/1.png",
                            "back_shiny_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/shiny/1.png",
                            "back_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/shiny/1.png",
                            "front_shiny_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/shiny/1.png",
                            "front_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/1.png"
                        },
                        "gold": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/1.png",
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/shiny/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/shiny/1.png",
                            "front_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/transparent/1.png"
                        },
                        "silver": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/1.png",
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/shiny/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/shiny/1.png",
                            "front_transparent": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/transparent/1.png"
                        }
                    },
                    "generation-iii": {
                        "emerald": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/shiny/1.png"
                        },
                        "firered-leafgreen": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/1.png",
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/shiny/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/shiny/1.png"
                        },
                        "ruby-sapphire": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/1.png",
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/shiny/1.png",
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/1.png",
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/shiny/1.png"
                        }
                    },
                    "generation-iv": {
                        "diamond-pearl": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/1.png",
                            "back_female": null,
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/shiny/1.png",
                            "back_shiny_female": null,
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/shiny/1.png",
                            "front_shiny_female": null
                        },
                        "heartgold-soulsilver": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/1.png",
                            "back_female": null,
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/shiny/1.png",
                            "back_shiny_female": null,
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/shiny/1.png",
                            "front_shiny_female": null
                        },
                        "platinum": {
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/1.png",
                            "back_female": null,
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/shiny/1.png",
                            "back_shiny_female": null,
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/shiny/1.png",
                            "front_shiny_female": null
                        }
                    },
                    "generation-v": {
                        "black-white": {
                            "animated": {
                                "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/1.gif",
                                "back_female": null,
                                "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/1.gif",
                                "back_shiny_female": null,
                                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif",
                                "front_female": null,
                                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/1.gif",
                                "front_shiny_female": null
                            },
                            "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/1.png",
                            "back_female": null,
                            "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/1.png",
                            "back_shiny_female": null,
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/1.png",
                            "front_shiny_female": null
                        }
                    },
                    "generation-vi": {
                        "omegaruby-alphasapphire": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/shiny/1.png",
                            "front_shiny_female": null
                        },
                        "x-y": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/shiny/1.png",
                            "front_shiny_female": null
                        }
                    },
                    "generation-vii": {
                        "icons": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/icons/1.png",
                            "front_female": null
                        },
                        "ultra-sun-ultra-moon": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/1.png",
                            "front_female": null,
                            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/shiny/1.png",
                            "front_shiny_female": null
                        }
                    },
                    "generation-viii": {
                        "icons": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-viii/icons/1.png",
                            "front_female": null
                        }
                    }
                }
            },
            "stats": [
                {
                    "base_stat": 45,
                    "effort": 0,
                    "stat": {
                        "name": "hp",
                        "url": "https://pokeapi.co/api/v2/stat/1/"
                    }
                },
                {
                    "base_stat": 49,
                    "effort": 0,
                    "stat": {
                        "name": "attack",
                        "url": "https://pokeapi.co/api/v2/stat/2/"
                    }
                },
                {
                    "base_stat": 49,
                    "effort": 0,
                    "stat": {
                        "name": "defense",
                        "url": "https://pokeapi.co/api/v2/stat/3/"
                    }
                },
                {
                    "base_stat": 65,
                    "effort": 1,
                    "stat": {
                        "name": "special-attack",
                        "url": "https://pokeapi.co/api/v2/stat/4/"
                    }
                },
                {
                    "base_stat": 65,
                    "effort": 0,
                    "stat": {
                        "name": "special-defense",
                        "url": "https://pokeapi.co/api/v2/stat/5/"
                    }
                },
                {
                    "base_stat": 45,
                    "effort": 0,
                    "stat": {
                        "name": "speed",
                        "url": "https://pokeapi.co/api/v2/stat/6/"
                    }
                }
            ],
            "types": [
                {
                    "slot": 1,
                    "type": {
                        "name": "grass",
                        "url": "https://pokeapi.co/api/v2/type/12/"
                    }
                },
                {
                    "slot": 2,
                    "type": {
                        "name": "poison",
                        "url": "https://pokeapi.co/api/v2/type/4/"
                    }
                }
            ],
            "weight": 69
        }
        """.data(using: .utf8)
    }
    
    static var emptyBulbasaurData: Data? {
        return  """
        {
            
        }
        """.data(using: .utf8)
    }
    
    static var bulbasaurPKMPokemon: PKMPokemon? {
        guard let bulbasaurData else {
            return nil
        }
        
        return try? PKMPokemon.decode(from: bulbasaurData)
    }
}

extension MockObject {
    
    class PokemonRemoteRepository: PokemonRemoteDataServices {
        
        func load(
            with currentPaginationObject: PKMPagedObject<PKMPokemon>?
        ) async throws -> PokemonRepositoryResult {
            let defaultInitialPagination = PKMPagedObject<PKMPokemon>(
                count: nil,
                next: nil,
                previous: nil,
                current: "",
                results: [],
                limit: 0,
                offset: 0
            
            )
            return .init(
                pokemons: [],
                hasMorePokemons: false,
                PKMPagination: MockObject.initalPaginationPokemonList ?? defaultInitialPagination
            )
        }

    }
    
    class PokemonLocalPersistence: PokemonLocalDataServices {
        
        func getPokemon(for id: Int) async throws -> Pokemon {
            throw PokemonLocalRepositoryError.pokemonNotFound
        }
        
        func getPokemons() async throws -> [Pokemon] {
            []
        }
        
        func getCurrentPaginationObject() async throws -> PKMPagedObject<PKMPokemon>? {
            return nil
        }
        
        func saveCurrentPokemons(
            with newPokemons: [Pokemon],
            with currentPaginationObject: PKMPagedObject<PKMPokemon>
        ) async throws {
            
        }
        
        func loadIntialState() async throws -> PokemonRepositoryResult? {
            return nil
        }
    }
    
    class EmptyUserSessionProvider: UserSessionServices {
        var isGuestUserAllowed: Bool = false
        
        var isSignedIn: Bool = true
        
        var isSignedInPublisher: AnyPublisher<Bool, Never> {
            Just(isSignedIn).eraseToAnyPublisher()
        }
        
        var didLoadInitialDataPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }
        
        func signIn() async {
            
        }
        
        func signOut() async {
            
        }
        
        func loadData() async {
            
        }
    }
}
