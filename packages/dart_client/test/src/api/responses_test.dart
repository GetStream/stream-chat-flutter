import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/src/api/responses.dart';
import 'package:stream_chat/src/models/device.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/stream_chat.dart';

void main() {
  group('src/api/responses', () {
    test('QueryChannelsResponse', () {
      const jsonExample = r'''{
    "channels": [
        {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        },
        {
            "channel": {
                "id": "spring-voice-7",
                "type": "messaging",
                "cid": "messaging:spring-voice-7",
                "last_message_at": "2020-01-28T22:17:31.194334Z",
                "created_at": "2020-01-28T22:17:30.858437Z",
                "updated_at": "2020-01-28T22:17:30.858438Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                }
            },
            "messages": [
                {
                    "id": "9db3ef01-e779-4279-8c54-ffd021eccec4",
                    "text": "A lustred seal is an alto of the mind.",
                    "html": "\u003cp\u003eA lustred seal is an alto of the mind.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.167579Z",
                    "updated_at": "2020-01-28T22:17:31.167579Z",
                    "mentioned_users": []
                },
                {
                    "id": "3232e92f-a96f-4b5e-bacb-3565e7155dc4",
                    "text": "https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Punisher Marvel GIF by NETFLIX - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                            "text": "See What's Next in entertainment and Netflix original series, movies, TV, docs, and comedies. You can stream Netflix anytime, anywhere, on any device.",
                            "image_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.168454Z",
                    "updated_at": "2020-01-28T22:17:31.168454Z",
                    "mentioned_users": []
                },
                {
                    "id": "ae6e196c-0a66-4941-9832-d66a40c95699",
                    "text": "A height of the parallelogram is assumed to be a sunfast cone.",
                    "html": "\u003cp\u003eA height of the parallelogram is assumed to be a sunfast cone.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.17494Z",
                    "updated_at": "2020-01-28T22:17:31.17494Z",
                    "mentioned_users": []
                },
                {
                    "id": "38fee958-1efe-456b-b2d2-7bd1ba975eab",
                    "text": "In modern times the braided bridge reveals itself as a daisied burn to those who look.",
                    "html": "\u003cp\u003eIn modern times the braided bridge reveals itself as a daisied burn to those who look.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "38fee958-1efe-456b-b2d2-7bd1ba975eab",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                                "name": "Spring voice"
                            },
                            "type": "like",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.213167Z",
                            "updated_at": "2020-01-28T22:17:31.213167Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "like": 1
                    },
                    "reaction_scores": {
                        "like": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.184974Z",
                    "updated_at": "2020-01-28T22:17:31.215223Z",
                    "mentioned_users": []
                },
                {
                    "id": "8dbc9bec-35c4-4c42-942a-5c97bd4400c0",
                    "text": "Nowhere is it disputed that some posit the unfiled japan to be less than fretted.",
                    "html": "\u003cp\u003eNowhere is it disputed that some posit the unfiled japan to be less than fretted.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "8dbc9bec-35c4-4c42-942a-5c97bd4400c0",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                                "name": "Spring voice"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.20517Z",
                            "updated_at": "2020-01-28T22:17:31.20517Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.18983Z",
                    "updated_at": "2020-01-28T22:17:31.207426Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "members": []
        },
        {
            "channel": {
                "id": "!members-1xFd7ZzcZ3c3ypDAOvvHynN4Yqy1TV5vw08XTxa4usg",
                "type": "messaging",
                "cid": "messaging:!members-1xFd7ZzcZ3c3ypDAOvvHynN4Yqy1TV5vw08XTxa4usg",
                "last_message_at": "2020-01-28T22:17:31.179366Z",
                "created_at": "2020-01-28T22:17:30.951407Z",
                "updated_at": "2020-01-28T22:17:30.951407Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Robin Papa",
                "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg"
            },
            "messages": [
                {
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
                {
                    "id": "0fe600b6-9cb7-4d1b-a9ba-eef7dd133b26",
                    "text": "A plagal ease without britishes is truly a james of premorse entrances.",
                    "html": "\u003cp\u003eA plagal ease without britishes is truly a james of premorse entrances.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "0fe600b6-9cb7-4d1b-a9ba-eef7dd133b26",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                                "name": "Spring voice"
                            },
                            "type": "wow",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.118131Z",
                            "updated_at": "2020-01-28T22:17:31.118131Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "wow": 1
                    },
                    "reaction_scores": {
                        "wow": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.1022Z",
                    "updated_at": "2020-01-28T22:17:31.123766Z",
                    "mentioned_users": []
                },
                {
                    "id": "4905cb95-c4db-42df-ac6c-5d6531f5f67b",
                    "text": "A lustred seal is an alto of the mind.",
                    "html": "\u003cp\u003eA lustred seal is an alto of the mind.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "4905cb95-c4db-42df-ac6c-5d6531f5f67b",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                                "name": "Spring voice"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.135966Z",
                            "updated_at": "2020-01-28T22:17:31.135966Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.103279Z",
                    "updated_at": "2020-01-28T22:17:31.142756Z",
                    "mentioned_users": []
                },
                {
                    "id": "549888c4-0d13-48ca-aaa5-7da8effb9c6f",
                    "text": "Before aftershaves, snowflakes were only deer.",
                    "html": "\u003cp\u003eBefore aftershaves, snowflakes were only deer.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.10644Z",
                    "updated_at": "2020-01-28T22:17:31.10644Z",
                    "mentioned_users": []
                },
                {
                    "id": "c74784e7-07ef-4b41-a8e3-b2b0e0b6b7ce",
                    "text": "https://unsplash.com/photos/JdGtvgzQmgQ",
                    "html": "\u003cp\u003e\u003ca href=\"https://unsplash.com/photos/JdGtvgzQmgQ\" rel=\"nofollow\"\u003ehttps://unsplash.com/photos/JdGtvgzQmgQ\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "title": "Photo by Markus Spiske on Unsplash",
                            "title_link": "https://unsplash.com/photos/JdGtvgzQmgQ",
                            "text": "THIS IS NOT A BOT – Save Your Internet – Demo against Uploadfilter – Article 13 #CensorshipMachine – March 16. 2019, Nürnberg, Germany. Download this photo by Markus Spiske on Unsplash",
                            "image_url": "https://images.unsplash.com/photo-1554272014-73b77edeb47f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "thumb_url": "https://images.unsplash.com/photo-1554272014-73b77edeb47f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "og_scrape_url": "https://unsplash.com/photos/JdGtvgzQmgQ"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "c74784e7-07ef-4b41-a8e3-b2b0e0b6b7ce",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "name": "Spring voice",
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice"
                            },
                            "type": "sad",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.131489Z",
                            "updated_at": "2020-01-28T22:17:31.131489Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "sad": 1
                    },
                    "reaction_scores": {
                        "sad": 1
                    },
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.11065Z",
                    "updated_at": "2020-01-28T22:17:31.133783Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "last_read": "2020-01-28T22:17:30.966485504Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:30.968339456Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "name": "Robin Papa",
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:30.95443Z",
                    "updated_at": "2020-01-28T22:17:30.95443Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:30.95443Z",
                    "updated_at": "2020-01-28T22:17:30.95443Z"
                }
            ]
        },
        {
            "channel": {
                "id": "!members-6ngG6o5HlqKK7B_YIWnamzM4O9IqkfuaFOLO0QVPP-0",
                "type": "messaging",
                "cid": "messaging:!members-6ngG6o5HlqKK7B_YIWnamzM4O9IqkfuaFOLO0QVPP-0",
                "last_message_at": "2020-01-28T22:17:31.171308Z",
                "created_at": "2020-01-28T22:17:30.891989Z",
                "updated_at": "2020-01-28T22:17:30.891989Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 5,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "image": "https://getstream.imgix.net/images/rn-chat-tutorial/caterpillar_01.png",
                "name": "Family"
            },
            "messages": [
                {
                    "id": "0bee6d7f-f479-47bb-998c-f449f6f30d74",
                    "text": "A described discovery's great-grandfather comes with it the thought that the topmost meter is a tsunami.",
                    "html": "\u003cp\u003eA described discovery’s great-grandfather comes with it the thought that the topmost meter is a tsunami.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "b816b921-ed3a-4d32-8e9e-f6eca413a7b0",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.8148Z",
                        "updated_at": "2020-01-28T22:17:31.08123Z",
                        "banned": false,
                        "online": false,
                        "name": "Micheal Murphy",
                        "image": "https://randomuser.me/api/portraits/men/95.jpg"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.068584Z",
                    "updated_at": "2020-01-28T22:17:31.068584Z",
                    "mentioned_users": []
                },
                {
                    "id": "76cd8c82-b557-4e48-9d12-87995d3a0e04",
                    "text": "The biggest driver reveals itself as a sclerosed mom to those who look.",
                    "html": "\u003cp\u003eThe biggest driver reveals itself as a sclerosed mom to those who look.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.810011Z",
                        "updated_at": "2020-01-28T22:17:31.077195Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/45.jpg",
                        "name": "Daisy Morgan"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "76cd8c82-b557-4e48-9d12-87995d3a0e04",
                            "user_id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                            "user": {
                                "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.810011Z",
                                "updated_at": "2020-01-28T22:17:31.077195Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/45.jpg",
                                "name": "Daisy Morgan"
                            },
                            "type": "wow",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.108742Z",
                            "updated_at": "2020-01-28T22:17:31.108742Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "wow": 1
                    },
                    "reaction_scores": {
                        "wow": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.077583Z",
                    "updated_at": "2020-01-28T22:17:31.111709Z",
                    "mentioned_users": []
                },
                {
                    "id": "358b8ab3-dd34-4baf-939e-f03617742486",
                    "text": "A spongy jail without bengals is truly a hawk of rattish canvases.",
                    "html": "\u003cp\u003eA spongy jail without bengals is truly a hawk of rattish canvases.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "b816b921-ed3a-4d32-8e9e-f6eca413a7b0",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.8148Z",
                        "updated_at": "2020-01-28T22:17:31.08123Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/men/95.jpg",
                        "name": "Micheal Murphy"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.08593Z",
                    "updated_at": "2020-01-28T22:17:31.08593Z",
                    "mentioned_users": []
                },
                {
                    "id": "5a559749-2f45-476e-9610-8eae92f3a5c6",
                    "text": "https://unsplash.com/photos/4v7ubW7jz1Q",
                    "html": "\u003cp\u003e\u003ca href=\"https://unsplash.com/photos/4v7ubW7jz1Q\" rel=\"nofollow\"\u003ehttps://unsplash.com/photos/4v7ubW7jz1Q\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.810011Z",
                        "updated_at": "2020-01-28T22:17:31.077195Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/45.jpg",
                        "name": "Daisy Morgan"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "title": "Photo by Joel Filipe on Unsplash",
                            "title_link": "https://unsplash.com/photos/4v7ubW7jz1Q",
                            "text": "Download this photo by Joel Filipe on Unsplash",
                            "image_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "thumb_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "og_scrape_url": "https://unsplash.com/photos/4v7ubW7jz1Q"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.090006Z",
                    "updated_at": "2020-01-28T22:17:31.090006Z",
                    "mentioned_users": []
                },
                {
                    "id": "da57c33b-ae12-438c-a672-4e5bad0d1467",
                    "text": "https://unsplash.com/photos/XttWKETqCCQ",
                    "html": "\u003cp\u003e\u003ca href=\"https://unsplash.com/photos/XttWKETqCCQ\" rel=\"nofollow\"\u003ehttps://unsplash.com/photos/XttWKETqCCQ\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "6e60091e-2173-4aa8-a6d2-1a79e4cad790",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.818618Z",
                        "updated_at": "2020-01-28T22:17:31.056057Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images.unsplash.com/photo-1502378735452-bc7d86632805?ixlib=rb-0.3.5\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max\u0026s=aa3a807e1bbdfd4364d1f449eaa96d82",
                        "name": "Carys Metz"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "title": "Photo by Olena Sergienko on Unsplash",
                            "title_link": "https://unsplash.com/photos/XttWKETqCCQ",
                            "text": "Download this photo by Olena Sergienko on Unsplash",
                            "image_url": "https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "thumb_url": "https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "og_scrape_url": "https://unsplash.com/photos/XttWKETqCCQ"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.171308Z",
                    "updated_at": "2020-01-28T22:17:31.171308Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "name": "Spring voice",
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice"
                    },
                    "last_read": "2020-01-28T22:17:30.916570624Z"
                },
                {
                    "user": {
                        "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.810011Z",
                        "updated_at": "2020-01-28T22:17:31.077195Z",
                        "banned": false,
                        "online": false,
                        "name": "Daisy Morgan",
                        "image": "https://randomuser.me/api/portraits/women/45.jpg"
                    },
                    "last_read": "2020-01-28T22:17:30.90931712Z"
                },
                {
                    "user": {
                        "id": "b816b921-ed3a-4d32-8e9e-f6eca413a7b0",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.8148Z",
                        "updated_at": "2020-01-28T22:17:31.08123Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/men/95.jpg",
                        "name": "Micheal Murphy"
                    },
                    "last_read": "2020-01-28T22:17:30.911188736Z"
                },
                {
                    "user": {
                        "id": "6e60091e-2173-4aa8-a6d2-1a79e4cad790",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.818618Z",
                        "updated_at": "2020-01-28T22:17:31.056057Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images.unsplash.com/photo-1502378735452-bc7d86632805?ixlib=rb-0.3.5\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max\u0026s=aa3a807e1bbdfd4364d1f449eaa96d82",
                        "name": "Carys Metz"
                    },
                    "last_read": "2020-01-28T22:17:30.912969472Z"
                },
                {
                    "user": {
                        "id": "dbcd6837-5d93-4b6e-ab27-ee13a490b873",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.822448Z",
                        "updated_at": "2020-01-28T22:17:30.823463Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjAwNjM3NjY5MF5BMl5BanBnXkFtZTcwMjM4NTYwOQ@@._V1_UY256_CR0,0,172,256_AL_.jpg",
                        "name": "Dakota Fanning"
                    },
                    "last_read": "2020-01-28T22:17:30.914806272Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "2de0297c-f3f2-489d-b930-ef77342edccf",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.810011Z",
                        "updated_at": "2020-01-28T22:17:31.077195Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/45.jpg",
                        "name": "Daisy Morgan"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:30.895522Z",
                    "updated_at": "2020-01-28T22:17:30.895522Z"
                },
                {
                    "user": {
                        "id": "6e60091e-2173-4aa8-a6d2-1a79e4cad790",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.818618Z",
                        "updated_at": "2020-01-28T22:17:31.056057Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images.unsplash.com/photo-1502378735452-bc7d86632805?ixlib=rb-0.3.5\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max\u0026s=aa3a807e1bbdfd4364d1f449eaa96d82",
                        "name": "Carys Metz"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:30.895522Z",
                    "updated_at": "2020-01-28T22:17:30.895522Z"
                },
                {
                    "user": {
                        "id": "b816b921-ed3a-4d32-8e9e-f6eca413a7b0",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.8148Z",
                        "updated_at": "2020-01-28T22:17:31.08123Z",
                        "banned": false,
                        "online": false,
                        "name": "Micheal Murphy",
                        "image": "https://randomuser.me/api/portraits/men/95.jpg"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:30.895522Z",
                    "updated_at": "2020-01-28T22:17:30.895522Z"
                },
                {
                    "user": {
                        "id": "dbcd6837-5d93-4b6e-ab27-ee13a490b873",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.822448Z",
                        "updated_at": "2020-01-28T22:17:30.823463Z",
                        "banned": false,
                        "online": false,
                        "name": "Dakota Fanning",
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjAwNjM3NjY5MF5BMl5BanBnXkFtZTcwMjM4NTYwOQ@@._V1_UY256_CR0,0,172,256_AL_.jpg"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:30.895523Z",
                    "updated_at": "2020-01-28T22:17:30.895523Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:30.895523Z",
                    "updated_at": "2020-01-28T22:17:30.895523Z"
                }
            ]
        },
        {
            "channel": {
                "id": "still-union-5",
                "type": "messaging",
                "cid": "messaging:still-union-5",
                "last_message_at": "2020-01-24T14:46:19.683016Z",
                "created_at": "2020-01-24T14:46:18.808933Z",
                "updated_at": "2020-01-24T14:46:18.808933Z",
                "created_by": {
                    "id": "still-union-5",
                    "role": "user",
                    "created_at": "2020-01-24T14:46:18.776236Z",
                    "updated_at": "2020-01-24T14:46:32.065913Z",
                    "last_active": "2020-01-24T14:46:32.05853Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                    "name": "Still union"
                },
                "frozen": false,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                }
            },
            "messages": [
                {
                    "id": "f77e582d-c4b3-461c-89de-9612a3bee8b1",
                    "text": "Some posit the phylloid cycle to be less than slimmer.",
                    "html": "\u003cp\u003eSome posit the phylloid cycle to be less than slimmer.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "f77e582d-c4b3-461c-89de-9612a3bee8b1",
                            "user_id": "still-union-5",
                            "user": {
                                "id": "still-union-5",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.776236Z",
                                "updated_at": "2020-01-24T14:46:32.065913Z",
                                "last_active": "2020-01-24T14:46:32.05853Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                                "name": "Still union"
                            },
                            "type": "angry",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.14806Z",
                            "updated_at": "2020-01-24T14:46:19.14806Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "angry": 1
                    },
                    "reaction_scores": {
                        "angry": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.127738Z",
                    "updated_at": "2020-01-24T14:46:19.149795Z",
                    "mentioned_users": []
                },
                {
                    "id": "82e2fbe7-4367-49e3-b80f-fc66e31e5afb",
                    "text": "A smarty panda is a cactus of the mind.",
                    "html": "\u003cp\u003eA smarty panda is a cactus of the mind.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.165153Z",
                    "updated_at": "2020-01-24T14:46:19.165154Z",
                    "mentioned_users": []
                },
                {
                    "id": "5a5ec35e-c925-4244-9d4c-098b32dd7fce",
                    "text": "https://unsplash.com/photos/4v7ubW7jz1Q",
                    "html": "\u003cp\u003e\u003ca href=\"https://unsplash.com/photos/4v7ubW7jz1Q\" rel=\"nofollow\"\u003ehttps://unsplash.com/photos/4v7ubW7jz1Q\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "title": "Photo by Joel Filipe on Unsplash",
                            "title_link": "https://unsplash.com/photos/4v7ubW7jz1Q",
                            "text": "Download this photo by Joel Filipe on Unsplash",
                            "image_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "thumb_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "og_scrape_url": "https://unsplash.com/photos/4v7ubW7jz1Q"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.168615Z",
                    "updated_at": "2020-01-24T14:46:19.168615Z",
                    "mentioned_users": []
                },
                {
                    "id": "bf27a1a7-911f-4432-8fe4-1d77a7736ef1",
                    "text": "A volumed ease's eyelash comes with it the thought that the unwiped energy is a flute.",
                    "html": "\u003cp\u003eA volumed ease’s eyelash comes with it the thought that the unwiped energy is a flute.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "name": "Still union",
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.171548Z",
                    "updated_at": "2020-01-24T14:46:19.171548Z",
                    "mentioned_users": []
                },
                {
                    "id": "9cecc024-a5fc-469f-a3a7-69f8bbeda40b",
                    "text": "https://www.youtube.com/watch?v=sCtixpIWBto",
                    "html": "\u003cp\u003e\u003ca href=\"https://www.youtube.com/watch?v=sCtixpIWBto\" rel=\"nofollow\"\u003ehttps://www.youtube.com/watch?v=sCtixpIWBto\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "name": "Still union",
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "YouTube",
                            "title": "Rachmaninoff - Prelude in C Sharp Minor (Op. 3 No. 2)",
                            "title_link": "https://www.youtube.com/watch?v=sCtixpIWBto",
                            "text": "Rachmaninoff - Prelude in C Sharp Minor (Op. 3 No. 2) Click the 🔔bell to always be notified on new uploads! ♫ Listen on Spotify: http://spoti.fi/2LdpqK7 ♫ MI...",
                            "image_url": "https://i.ytimg.com/vi/sCtixpIWBto/maxresdefault.jpg",
                            "thumb_url": "https://i.ytimg.com/vi/sCtixpIWBto/maxresdefault.jpg",
                            "asset_url": "https://www.youtube.com/embed/sCtixpIWBto",
                            "og_scrape_url": "https://www.youtube.com/watch?v=sCtixpIWBto"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "9cecc024-a5fc-469f-a3a7-69f8bbeda40b",
                            "user_id": "still-union-5",
                            "user": {
                                "id": "still-union-5",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.776236Z",
                                "updated_at": "2020-01-24T14:46:32.065913Z",
                                "last_active": "2020-01-24T14:46:32.05853Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                                "name": "Still union"
                            },
                            "type": "like",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.703554Z",
                            "updated_at": "2020-01-24T14:46:19.703554Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "like": 1
                    },
                    "reaction_scores": {
                        "like": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.683016Z",
                    "updated_at": "2020-01-24T14:46:19.705034Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "members": []
        },
        {
            "channel": {
                "id": "!members-9CAnYw3rnRNrqnSyxvA1rQyL6HLVTt1KUgAz1CeoEvo",
                "type": "messaging",
                "cid": "messaging:!members-9CAnYw3rnRNrqnSyxvA1rQyL6HLVTt1KUgAz1CeoEvo",
                "last_message_at": "2020-01-24T14:46:19.168507Z",
                "created_at": "2020-01-24T14:46:18.846673Z",
                "updated_at": "2020-01-24T14:46:18.846673Z",
                "created_by": {
                    "id": "still-union-5",
                    "role": "user",
                    "created_at": "2020-01-24T14:46:18.776236Z",
                    "updated_at": "2020-01-24T14:46:32.065913Z",
                    "last_active": "2020-01-24T14:46:32.05853Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                    "name": "Still union"
                },
                "frozen": false,
                "member_count": 5,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "image": "https://getstream.imgix.net/images/rn-chat-tutorial/caterpillar_01.png",
                "name": "Family"
            },
            "messages": [
                {
                    "id": "a5ee396a-34bf-42d9-8388-819e84d770e2",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "7cdf7f97-c336-4263-9430-42a1f4d165c8",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.764869Z",
                        "updated_at": "2020-01-24T14:46:19.007916Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.014504Z",
                    "updated_at": "2020-01-24T14:46:19.014505Z",
                    "mentioned_users": []
                },
                {
                    "id": "31bdba04-b86f-48d6-91d9-972bb50e3ffe",
                    "text": "A chiefly care is a pressure of the mind.",
                    "html": "\u003cp\u003eA chiefly care is a pressure of the mind.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "5a46018e-252b-4598-a7e8-40949c3be4d6",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.783718Z",
                        "updated_at": "2020-01-24T14:46:19.096044Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/44.jpg",
                        "name": "June Cha"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.050641Z",
                    "updated_at": "2020-01-24T14:46:19.050641Z",
                    "mentioned_users": []
                },
                {
                    "id": "bc08ad2e-4da0-4d9f-b349-4e9b85d45899",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "694bc286-80d5-4be5-81f8-068028d561e4",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.760346Z",
                        "updated_at": "2020-01-24T14:46:19.132067Z",
                        "banned": false,
                        "online": false,
                        "name": "Adelle Charles",
                        "image": "https://pbs.twimg.com/profile_images/1108790938640531456/Bl2JvdG_.png"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "bc08ad2e-4da0-4d9f-b349-4e9b85d45899",
                            "user_id": "694bc286-80d5-4be5-81f8-068028d561e4",
                            "user": {
                                "id": "694bc286-80d5-4be5-81f8-068028d561e4",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.760346Z",
                                "updated_at": "2020-01-24T14:46:19.132067Z",
                                "banned": false,
                                "online": false,
                                "image": "https://pbs.twimg.com/profile_images/1108790938640531456/Bl2JvdG_.png",
                                "name": "Adelle Charles"
                            },
                            "type": "angry",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.08354Z",
                            "updated_at": "2020-01-24T14:46:19.08354Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "angry": 1
                    },
                    "reaction_scores": {
                        "angry": 1
                    },
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.055407Z",
                    "updated_at": "2020-01-24T14:46:19.08681Z",
                    "mentioned_users": []
                },
                {
                    "id": "9b0063ad-cd62-4dc7-ba21-3feee5853122",
                    "text": "A height of the parallelogram is assumed to be a sunfast cone.",
                    "html": "\u003cp\u003eA height of the parallelogram is assumed to be a sunfast cone.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "9b0063ad-cd62-4dc7-ba21-3feee5853122",
                            "user_id": "still-union-5",
                            "user": {
                                "id": "still-union-5",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.776236Z",
                                "updated_at": "2020-01-24T14:46:32.065913Z",
                                "last_active": "2020-01-24T14:46:32.05853Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                                "name": "Still union"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.094595Z",
                            "updated_at": "2020-01-24T14:46:19.094595Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.068177Z",
                    "updated_at": "2020-01-24T14:46:19.096185Z",
                    "mentioned_users": []
                },
                {
                    "id": "4f11cd19-66cc-4fc4-b153-9eced2518e21",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "694bc286-80d5-4be5-81f8-068028d561e4",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.760346Z",
                        "updated_at": "2020-01-24T14:46:19.132067Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/1108790938640531456/Bl2JvdG_.png",
                        "name": "Adelle Charles"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "4f11cd19-66cc-4fc4-b153-9eced2518e21",
                            "user_id": "still-union-5",
                            "user": {
                                "id": "still-union-5",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.776236Z",
                                "updated_at": "2020-01-24T14:46:32.065913Z",
                                "last_active": "2020-01-24T14:46:32.05853Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                                "name": "Still union"
                            },
                            "type": "haha",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.110667Z",
                            "updated_at": "2020-01-24T14:46:19.110667Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "haha": 1
                    },
                    "reaction_scores": {
                        "haha": 1
                    },
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.077713Z",
                    "updated_at": "2020-01-24T14:46:19.113185Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "0f345a0c-3f35-4e2f-805e-77f53f8332cd",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.779973Z",
                        "updated_at": "2020-01-24T14:46:19.157321Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMDc2M2NkMTctNmQ0MS00MjQxLWFkMGItNGY1Y2Y3NzYzZjg1XkEyXkFqcGdeQXVyNjAzMTgxNjY@._V1_UY256_CR74,0,172,256_AL_.jpg",
                        "name": "Zoe McLellan"
                    },
                    "last_read": "2020-01-24T14:46:18.863312384Z"
                },
                {
                    "user": {
                        "id": "5a46018e-252b-4598-a7e8-40949c3be4d6",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.783718Z",
                        "updated_at": "2020-01-24T14:46:19.096044Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/44.jpg",
                        "name": "June Cha"
                    },
                    "last_read": "2020-01-24T14:46:18.8644352Z"
                },
                {
                    "user": {
                        "id": "7cdf7f97-c336-4263-9430-42a1f4d165c8",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.764869Z",
                        "updated_at": "2020-01-24T14:46:19.007916Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "last_read": "2020-01-24T14:46:18.866511104Z"
                },
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "last_read": "2020-01-24T14:46:18.867566336Z"
                },
                {
                    "user": {
                        "id": "694bc286-80d5-4be5-81f8-068028d561e4",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.760346Z",
                        "updated_at": "2020-01-24T14:46:19.132067Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/1108790938640531456/Bl2JvdG_.png",
                        "name": "Adelle Charles"
                    },
                    "last_read": "2020-01-24T14:46:18.865476096Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "0f345a0c-3f35-4e2f-805e-77f53f8332cd",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.779973Z",
                        "updated_at": "2020-01-24T14:46:19.157321Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMDc2M2NkMTctNmQ0MS00MjQxLWFkMGItNGY1Y2Y3NzYzZjg1XkEyXkFqcGdeQXVyNjAzMTgxNjY@._V1_UY256_CR74,0,172,256_AL_.jpg",
                        "name": "Zoe McLellan"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.850178Z",
                    "updated_at": "2020-01-24T14:46:18.850178Z"
                },
                {
                    "user": {
                        "id": "5a46018e-252b-4598-a7e8-40949c3be4d6",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.783718Z",
                        "updated_at": "2020-01-24T14:46:19.096044Z",
                        "banned": false,
                        "online": false,
                        "name": "June Cha",
                        "image": "https://randomuser.me/api/portraits/women/44.jpg"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.850179Z",
                    "updated_at": "2020-01-24T14:46:18.850179Z"
                },
                {
                    "user": {
                        "id": "694bc286-80d5-4be5-81f8-068028d561e4",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.760346Z",
                        "updated_at": "2020-01-24T14:46:19.132067Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/1108790938640531456/Bl2JvdG_.png",
                        "name": "Adelle Charles"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.850179Z",
                    "updated_at": "2020-01-24T14:46:18.850179Z"
                },
                {
                    "user": {
                        "id": "7cdf7f97-c336-4263-9430-42a1f4d165c8",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.764869Z",
                        "updated_at": "2020-01-24T14:46:19.007916Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.850179Z",
                    "updated_at": "2020-01-24T14:46:18.850179Z"
                },
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "role": "owner",
                    "created_at": "2020-01-24T14:46:18.85018Z",
                    "updated_at": "2020-01-24T14:46:18.85018Z"
                }
            ]
        },
        {
            "channel": {
                "id": "!members-Hc19Pf6huW0QTLRkQscRvline00uxqpj2OAYIcxTPFw",
                "type": "messaging",
                "cid": "messaging:!members-Hc19Pf6huW0QTLRkQscRvline00uxqpj2OAYIcxTPFw",
                "last_message_at": "2020-01-24T14:46:19.16305Z",
                "created_at": "2020-01-24T14:46:18.953227Z",
                "updated_at": "2020-01-24T14:46:18.953227Z",
                "created_by": {
                    "id": "still-union-5",
                    "role": "user",
                    "created_at": "2020-01-24T14:46:18.776236Z",
                    "updated_at": "2020-01-24T14:46:32.065913Z",
                    "last_active": "2020-01-24T14:46:32.05853Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                    "name": "Still union"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "image": "https://randomuser.me/api/portraits/women/8.jpg",
                "name": "Jennifer Fritz"
            },
            "messages": [
                {
                    "id": "17b0dc4a-78b3-4e08-860e-11ad2d8ac89d",
                    "text": "Extending this logic, the witted tree reveals itself as a glummest danger to those who look.",
                    "html": "\u003cp\u003eExtending this logic, the witted tree reveals itself as a glummest danger to those who look.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "17b0dc4a-78b3-4e08-860e-11ad2d8ac89d",
                            "user_id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                            "user": {
                                "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.772459Z",
                                "updated_at": "2020-01-24T14:46:19.151717Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/8.jpg",
                                "name": "Jennifer Fritz"
                            },
                            "type": "like",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.08279Z",
                            "updated_at": "2020-01-24T14:46:19.08279Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "like": 1
                    },
                    "reaction_scores": {
                        "like": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.051688Z",
                    "updated_at": "2020-01-24T14:46:19.085197Z",
                    "mentioned_users": []
                },
                {
                    "id": "ca22e5e3-5f2c-456e-8699-522cba94d177",
                    "text": "A cricoid melody without replaces is truly a cocktail of unripe badgers.",
                    "html": "\u003cp\u003eA cricoid melody without replaces is truly a cocktail of unripe badgers.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.772459Z",
                        "updated_at": "2020-01-24T14:46:19.151717Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/8.jpg",
                        "name": "Jennifer Fritz"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "ca22e5e3-5f2c-456e-8699-522cba94d177",
                            "user_id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                            "user": {
                                "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.772459Z",
                                "updated_at": "2020-01-24T14:46:19.151717Z",
                                "banned": false,
                                "online": false,
                                "name": "Jennifer Fritz",
                                "image": "https://randomuser.me/api/portraits/women/8.jpg"
                            },
                            "type": "like",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.133825Z",
                            "updated_at": "2020-01-24T14:46:19.133825Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "like": 1
                    },
                    "reaction_scores": {
                        "like": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.10105Z",
                    "updated_at": "2020-01-24T14:46:19.135877Z",
                    "mentioned_users": []
                },
                {
                    "id": "494916be-b66b-48b0-a1c5-bb2cab32eb7a",
                    "text": "The first towy harmony is, in its own way, a voyage.",
                    "html": "\u003cp\u003eThe first towy harmony is, in its own way, a voyage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.115607Z",
                    "updated_at": "2020-01-24T14:46:19.115608Z",
                    "mentioned_users": []
                },
                {
                    "id": "633c149b-2b1d-461a-8dfe-0f941acc34d4",
                    "text": "A bicycle can hardly be considered a yearning jar without also being an alley.",
                    "html": "\u003cp\u003eA bicycle can hardly be considered a yearning jar without also being an alley.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.772459Z",
                        "updated_at": "2020-01-24T14:46:19.151717Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/8.jpg",
                        "name": "Jennifer Fritz"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.135028Z",
                    "updated_at": "2020-01-24T14:46:19.135028Z",
                    "mentioned_users": []
                },
                {
                    "id": "2378fa62-8a5f-4dd3-8ea0-e0276e682c8a",
                    "text": "https://unsplash.com/photos/4v7ubW7jz1Q",
                    "html": "\u003cp\u003e\u003ca href=\"https://unsplash.com/photos/4v7ubW7jz1Q\" rel=\"nofollow\"\u003ehttps://unsplash.com/photos/4v7ubW7jz1Q\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.772459Z",
                        "updated_at": "2020-01-24T14:46:19.151717Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/8.jpg",
                        "name": "Jennifer Fritz"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "title": "Photo by Joel Filipe on Unsplash",
                            "title_link": "https://unsplash.com/photos/4v7ubW7jz1Q",
                            "text": "Download this photo by Joel Filipe on Unsplash",
                            "image_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "thumb_url": "https://images.unsplash.com/photo-1557389352-e721da78ad9f?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max\u0026ixid=eyJhcHBfaWQiOjEyMDd9",
                            "og_scrape_url": "https://unsplash.com/photos/4v7ubW7jz1Q"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.140074Z",
                    "updated_at": "2020-01-24T14:46:19.140075Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "last_read": "2020-01-24T14:46:18.969139712Z"
                },
                {
                    "user": {
                        "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.772459Z",
                        "updated_at": "2020-01-24T14:46:19.151717Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/8.jpg",
                        "name": "Jennifer Fritz"
                    },
                    "last_read": "2020-01-24T14:46:18.96800512Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "05ab6a02-9160-47b7-87d9-c6888fa85f83",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.772459Z",
                        "updated_at": "2020-01-24T14:46:19.151717Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/8.jpg",
                        "name": "Jennifer Fritz"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.956793Z",
                    "updated_at": "2020-01-24T14:46:18.956793Z"
                },
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "role": "owner",
                    "created_at": "2020-01-24T14:46:18.956793Z",
                    "updated_at": "2020-01-24T14:46:18.956793Z"
                }
            ]
        },
        {
            "channel": {
                "id": "!members-og1pgcoaqCSdh6KyIXz4qKB_d22pnWth6Yfbovd8yP0",
                "type": "messaging",
                "cid": "messaging:!members-og1pgcoaqCSdh6KyIXz4qKB_d22pnWth6Yfbovd8yP0",
                "last_message_at": "2020-01-24T14:46:19.124398Z",
                "created_at": "2020-01-24T14:46:18.902415Z",
                "updated_at": "2020-01-24T14:46:18.902415Z",
                "created_by": {
                    "id": "still-union-5",
                    "role": "user",
                    "created_at": "2020-01-24T14:46:18.776236Z",
                    "updated_at": "2020-01-24T14:46:32.065913Z",
                    "last_active": "2020-01-24T14:46:32.05853Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                    "name": "Still union"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Ana De Armas",
                "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg"
            },
            "messages": [
                {
                    "id": "1aec347f-c1c4-4d83-ab42-76a12d3d3da2",
                    "text": "Before aftershaves, snowflakes were only deer.",
                    "html": "\u003cp\u003eBefore aftershaves, snowflakes were only deer.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.057578Z",
                    "updated_at": "2020-01-24T14:46:19.057578Z",
                    "mentioned_users": []
                },
                {
                    "id": "1ec1473d-405d-4a3c-b771-ab09fcbe071f",
                    "text": "https://giphy.com/gifs/movie-trailer-gemini-man-QsU9X0AxxfSAwsaz7n",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/movie-trailer-gemini-man-QsU9X0AxxfSAwsaz7n\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/movie-trailer-gemini-man-QsU9X0AxxfSAwsaz7n\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Gemini Man Trailer GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/QsU9X0AxxfSAwsaz7n/giphy.gif",
                            "text": "Discover \u0026 share this Gemini Man GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/QsU9X0AxxfSAwsaz7n/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/QsU9X0AxxfSAwsaz7n/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/QsU9X0AxxfSAwsaz7n/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/movie-trailer-gemini-man-QsU9X0AxxfSAwsaz7n"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.076425Z",
                    "updated_at": "2020-01-24T14:46:19.076425Z",
                    "mentioned_users": []
                },
                {
                    "id": "3c6b5f22-da06-470e-bb7f-499fa7466de0",
                    "text": "Their chord was, in this moment, a slipshod parenthesis.",
                    "html": "\u003cp\u003eTheir chord was, in this moment, a slipshod parenthesis.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.768629Z",
                        "updated_at": "2020-01-24T14:46:19.076467Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg",
                        "name": "Ana De Armas"
                    },
                    "attachments": [],
                    "latest_reactions": [
                        {
                            "message_id": "3c6b5f22-da06-470e-bb7f-499fa7466de0",
                            "user_id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                            "user": {
                                "id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                                "role": "user",
                                "created_at": "2020-01-24T14:46:18.768629Z",
                                "updated_at": "2020-01-24T14:46:19.076467Z",
                                "banned": false,
                                "online": false,
                                "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg",
                                "name": "Ana De Armas"
                            },
                            "type": "like",
                            "score": 1,
                            "created_at": "2020-01-24T14:46:19.118307Z",
                            "updated_at": "2020-01-24T14:46:19.118307Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "like": 1
                    },
                    "reaction_scores": {
                        "like": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.078556Z",
                    "updated_at": "2020-01-24T14:46:19.120491Z",
                    "mentioned_users": []
                },
                {
                    "id": "86eb957d-54fd-4ed9-8e80-1bb3212e57ea",
                    "text": "However, the porcine puffin reveals itself as an uncaught mirror to those who look.",
                    "html": "\u003cp\u003eHowever, the porcine puffin reveals itself as an uncaught mirror to those who look.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-24T14:46:19.078749Z",
                    "updated_at": "2020-01-24T14:46:19.07875Z",
                    "mentioned_users": []
                },
                {
                    "id": "179eb482-b005-4b34-965c-22b1dbb60a8e",
                    "text": "A parklike screw without ants is truly a fly of hooly rings.",
                    "html": "\u003cp\u003eA parklike screw without ants is truly a fly of hooly rings.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.768629Z",
                        "updated_at": "2020-01-24T14:46:19.076467Z",
                        "banned": false,
                        "online": false,
                        "name": "Ana De Armas",
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-24T14:46:19.080192Z",
                    "updated_at": "2020-01-24T14:46:19.080192Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "last_read": "2020-01-24T14:46:18.92038528Z"
                },
                {
                    "user": {
                        "id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.768629Z",
                        "updated_at": "2020-01-24T14:46:19.076467Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg",
                        "name": "Ana De Armas"
                    },
                    "last_read": "2020-01-24T14:46:18.919357952Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "db375ac9-6a3f-4d9c-a5ea-4cd6c169fd09",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.768629Z",
                        "updated_at": "2020-01-24T14:46:19.076467Z",
                        "banned": false,
                        "online": false,
                        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMjA3NjYzMzE1MV5BMl5BanBnXkFtZTgwNTA4NDY4OTE@._V1_UX172_CR0,0,172,256_AL_.jpg",
                        "name": "Ana De Armas"
                    },
                    "role": "member",
                    "created_at": "2020-01-24T14:46:18.905968Z",
                    "updated_at": "2020-01-24T14:46:18.905968Z"
                },
                {
                    "user": {
                        "id": "still-union-5",
                        "role": "user",
                        "created_at": "2020-01-24T14:46:18.776236Z",
                        "updated_at": "2020-01-24T14:46:32.065913Z",
                        "last_active": "2020-01-24T14:46:32.05853Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=still-union-5\u0026amp;name=Still+union",
                        "name": "Still union"
                    },
                    "role": "owner",
                    "created_at": "2020-01-24T14:46:18.905968Z",
                    "updated_at": "2020-01-24T14:46:18.905968Z"
                }
            ]
        },
        {
            "channel": {
                "id": "holy-sun-6",
                "type": "messaging",
                "cid": "messaging:holy-sun-6",
                "last_message_at": "2020-01-23T00:52:40.316069Z",
                "created_at": "2020-01-23T00:52:39.457615Z",
                "updated_at": "2020-01-23T00:52:39.457615Z",
                "created_by": {
                    "id": "holy-sun-6",
                    "role": "user",
                    "created_at": "2020-01-23T00:52:39.412193Z",
                    "updated_at": "2020-01-23T00:52:40.211607Z",
                    "banned": false,
                    "online": false,
                    "name": "Holy sun",
                    "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun"
                },
                "frozen": false,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                }
            },
            "messages": [
                {
                    "id": "d0843e2b-2dd8-404e-a4a4-3730287d144b",
                    "text": "A robert of the august is assumed to be an accurst fortnight.",
                    "html": "\u003cp\u003eA robert of the august is assumed to be an accurst fortnight.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:39.828172Z",
                    "updated_at": "2020-01-23T00:52:39.828172Z",
                    "mentioned_users": []
                },
                {
                    "id": "af6c4391-be20-4b25-b824-b4751507cd33",
                    "text": "Authors often misinterpret the railway as a louvred range, when in actuality it feels more like a pitted fridge.",
                    "html": "\u003cp\u003eAuthors often misinterpret the railway as a louvred range, when in actuality it feels more like a pitted fridge.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:39.850576Z",
                    "updated_at": "2020-01-23T00:52:39.850577Z",
                    "mentioned_users": []
                },
                {
                    "id": "960d62ad-00c6-4237-9b3c-cd440408ea18",
                    "text": "A dugout can hardly be considered a soundless acknowledgment without also being a raft.",
                    "html": "\u003cp\u003eA dugout can hardly be considered a soundless acknowledgment without also being a raft.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:39.873187Z",
                    "updated_at": "2020-01-23T00:52:39.873187Z",
                    "mentioned_users": []
                },
                {
                    "id": "409074d7-c830-4c16-9205-393de08898d3",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-23T00:52:40.191037Z",
                    "updated_at": "2020-01-23T00:52:40.191037Z",
                    "mentioned_users": []
                },
                {
                    "id": "2f1b8944-014a-4753-886f-1042163ada46",
                    "text": "https://www.youtube.com/watch?v=sCtixpIWBto",
                    "html": "\u003cp\u003e\u003ca href=\"https://www.youtube.com/watch?v=sCtixpIWBto\" rel=\"nofollow\"\u003ehttps://www.youtube.com/watch?v=sCtixpIWBto\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "YouTube",
                            "title": "Rachmaninoff - Prelude in C Sharp Minor (Op. 3 No. 2)",
                            "title_link": "https://www.youtube.com/watch?v=sCtixpIWBto",
                            "text": "Rachmaninoff - Prelude in C Sharp Minor (Op. 3 No. 2) Click the 🔔bell to always be notified on new uploads! ♫ Listen on Spotify: http://spoti.fi/2LdpqK7 ♫ MI...",
                            "image_url": "https://i.ytimg.com/vi/sCtixpIWBto/maxresdefault.jpg",
                            "thumb_url": "https://i.ytimg.com/vi/sCtixpIWBto/maxresdefault.jpg",
                            "asset_url": "https://www.youtube.com/embed/sCtixpIWBto",
                            "og_scrape_url": "https://www.youtube.com/watch?v=sCtixpIWBto"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "2f1b8944-014a-4753-886f-1042163ada46",
                            "user_id": "holy-sun-6",
                            "user": {
                                "id": "holy-sun-6",
                                "role": "user",
                                "created_at": "2020-01-23T00:52:39.412193Z",
                                "updated_at": "2020-01-23T00:52:40.211607Z",
                                "banned": false,
                                "online": false,
                                "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                                "name": "Holy sun"
                            },
                            "type": "haha",
                            "score": 1,
                            "created_at": "2020-01-23T00:52:40.336054Z",
                            "updated_at": "2020-01-23T00:52:40.336054Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "haha": 1
                    },
                    "reaction_scores": {
                        "haha": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:40.316069Z",
                    "updated_at": "2020-01-23T00:52:40.337791Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "members": []
        },
        {
            "channel": {
                "id": "!members-aOjLAUKF7f4tB6iysBURUm7soQp6BBPpr0chg1KjGAA",
                "type": "messaging",
                "cid": "messaging:!members-aOjLAUKF7f4tB6iysBURUm7soQp6BBPpr0chg1KjGAA",
                "last_message_at": "2020-01-23T00:52:40.193868Z",
                "created_at": "2020-01-23T00:52:39.556322Z",
                "updated_at": "2020-01-23T00:52:39.556322Z",
                "created_by": {
                    "id": "holy-sun-6",
                    "role": "user",
                    "created_at": "2020-01-23T00:52:39.412193Z",
                    "updated_at": "2020-01-23T00:52:40.211607Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                    "name": "Holy sun"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "image": "https://randomuser.me/api/portraits/women/65.jpg",
                "name": "Renee Sims"
            },
            "messages": [
                {
                    "id": "0fd2c220-4871-49d6-873d-84e7e12782e9",
                    "text": "A smarty panda is a cactus of the mind.",
                    "html": "\u003cp\u003eA smarty panda is a cactus of the mind.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.43164Z",
                        "updated_at": "2020-01-23T00:52:39.798407Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/65.jpg",
                        "name": "Renee Sims"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:39.763764Z",
                    "updated_at": "2020-01-23T00:52:39.763764Z",
                    "mentioned_users": []
                },
                {
                    "id": "85a2e430-f9af-4e60-a43e-c87e48102aa7",
                    "text": "We can assume that any instance of a half-brother can be construed as an allowed half-brother.",
                    "html": "\u003cp\u003eWe can assume that any instance of a half-brother can be construed as an allowed half-brother.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-23T00:52:39.764235Z",
                    "updated_at": "2020-01-23T00:52:39.764236Z",
                    "mentioned_users": []
                },
                {
                    "id": "8bc5aeb6-6b39-488f-95ac-8c4bbb704b0e",
                    "text": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr",
                    "html": "\u003cp\u003e\u003ca href=\"https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr\" rel=\"nofollow\"\u003ehttps://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "author_name": "Science News",
                            "title": "Peacock spiders’ superblack spots reflect just 0.5 percent of light",
                            "title_link": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light",
                            "text": "By manipulating light with tiny structures, patches on peacock spiders appear superblack, helping accentuate the arachnids’ bright colors.",
                            "image_url": "https://www.sciencenews.org/wp-content/uploads/2019/05/051419_cw_spider_feat.jpg",
                            "thumb_url": "https://www.sciencenews.org/wp-content/uploads/2019/05/051419_cw_spider_feat.jpg",
                            "og_scrape_url": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "8bc5aeb6-6b39-488f-95ac-8c4bbb704b0e",
                            "user_id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                            "user": {
                                "id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                                "role": "user",
                                "created_at": "2020-01-23T00:52:39.43164Z",
                                "updated_at": "2020-01-23T00:52:39.798407Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/65.jpg",
                                "name": "Renee Sims"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-23T00:52:40.173357Z",
                            "updated_at": "2020-01-23T00:52:40.173357Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:40.151326Z",
                    "updated_at": "2020-01-23T00:52:40.175705Z",
                    "mentioned_users": []
                },
                {
                    "id": "4dc8a789-3930-44b7-9707-7302209189fb",
                    "text": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr",
                    "html": "\u003cp\u003e\u003ca href=\"https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr\" rel=\"nofollow\"\u003ehttps://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.43164Z",
                        "updated_at": "2020-01-23T00:52:39.798407Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/65.jpg",
                        "name": "Renee Sims"
                    },
                    "attachments": [
                        {
                            "type": "image",
                            "author_name": "Science News",
                            "title": "Peacock spiders’ superblack spots reflect just 0.5 percent of light",
                            "title_link": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light",
                            "text": "By manipulating light with tiny structures, patches on peacock spiders appear superblack, helping accentuate the arachnids’ bright colors.",
                            "image_url": "https://www.sciencenews.org/wp-content/uploads/2019/05/051419_cw_spider_feat.jpg",
                            "thumb_url": "https://www.sciencenews.org/wp-content/uploads/2019/05/051419_cw_spider_feat.jpg",
                            "og_scrape_url": "https://www.sciencenews.org/article/peacock-spiders-superblack-spots-reflect-just-05-percent-light?tgt=nr"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:40.151921Z",
                    "updated_at": "2020-01-23T00:52:40.151921Z",
                    "mentioned_users": []
                },
                {
                    "id": "793722c6-5bbc-408c-8ba9-e1728e09d7c3",
                    "text": "https://www.youtube.com/watch?v=cJCtiJydw9U",
                    "html": "\u003cp\u003e\u003ca href=\"https://www.youtube.com/watch?v=cJCtiJydw9U\" rel=\"nofollow\"\u003ehttps://www.youtube.com/watch?v=cJCtiJydw9U\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "YouTube",
                            "title": "まるです１１。-I am Maru 11.-",
                            "title_link": "https://www.youtube.com/watch?v=cJCtiJydw9U",
                            "text": "Happy 11th birthday!! BGM channel by h/mix -秋山裕和 公式チャンネル- https://www.youtube.com/channel/UCNPMwbX6-SclEmvFX5_ihCw Blog: http://sisinmaru.com/ Instagram: htt...",
                            "image_url": "https://i.ytimg.com/vi/cJCtiJydw9U/maxresdefault.jpg",
                            "thumb_url": "https://i.ytimg.com/vi/cJCtiJydw9U/maxresdefault.jpg",
                            "asset_url": "https://www.youtube.com/embed/cJCtiJydw9U",
                            "og_scrape_url": "https://www.youtube.com/watch?v=cJCtiJydw9U"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-23T00:52:40.193868Z",
                    "updated_at": "2020-01-23T00:52:40.193868Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.43164Z",
                        "updated_at": "2020-01-23T00:52:39.798407Z",
                        "banned": false,
                        "online": false,
                        "name": "Renee Sims",
                        "image": "https://randomuser.me/api/portraits/women/65.jpg"
                    },
                    "last_read": "2020-01-23T00:52:39.570845184Z"
                },
                {
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "last_read": "2020-01-23T00:52:39.572206592Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "636fdc1b-8b86-47b0-8ea1-8bb7f7c38910",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.43164Z",
                        "updated_at": "2020-01-23T00:52:39.798407Z",
                        "banned": false,
                        "online": false,
                        "name": "Renee Sims",
                        "image": "https://randomuser.me/api/portraits/women/65.jpg"
                    },
                    "role": "member",
                    "created_at": "2020-01-23T00:52:39.559506Z",
                    "updated_at": "2020-01-23T00:52:39.559506Z"
                },
                {
                    "user": {
                        "id": "holy-sun-6",
                        "role": "user",
                        "created_at": "2020-01-23T00:52:39.412193Z",
                        "updated_at": "2020-01-23T00:52:40.211607Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=holy-sun-6\u0026name=Holy+sun",
                        "name": "Holy sun"
                    },
                    "role": "owner",
                    "created_at": "2020-01-23T00:52:39.559506Z",
                    "updated_at": "2020-01-23T00:52:39.559506Z"
                }
            ]
        }
    ],
    "duration": "30.85ms"
}''';
      final response = QueryChannelsResponse.fromJson(json.decode(jsonExample));
      expect(response.channels, isA<List<ChannelState>>());
    });

    test('ChannelStateResponse', () {
      const jsonExample = r'''
      {
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
            "messages": [
                {
                    "id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                    "text": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "The Lion King Disney GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "text": "Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA"
                        }
                    ],
                    "latest_reactions": [
                        {
                            "message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f",
                            "user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                            "user": {
                                "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.83015Z",
                                "updated_at": "2020-01-28T22:17:31.19435Z",
                                "banned": false,
                                "online": false,
                                "image": "https://randomuser.me/api/portraits/women/2.jpg",
                                "name": "Mia Denys"
                            },
                            "type": "love",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.128376Z",
                            "updated_at": "2020-01-28T22:17:31.128376Z"
                        }
                    ],
                    "own_reactions": [],
                    "reaction_counts": {
                        "love": 1
                    },
                    "reaction_scores": {
                        "love": 1
                    },
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.107978Z",
                    "updated_at": "2020-01-28T22:17:31.130506Z",
                    "mentioned_users": []
                },
                {
                    "id": "16e19c46-fb96-4f89-8031-d5bd2ce3bd64",
                    "text": "Few can name a topfull mother that isn't a breezeless damage.",
                    "html": "\u003cp\u003eFew can name a topfull mother that isn’t a breezeless damage.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.153518Z",
                    "updated_at": "2020-01-28T22:17:31.153518Z",
                    "mentioned_users": []
                },
                {
                    "id": "38b1b252-c9a6-4aea-a39e-8de3b7f7604b",
                    "text": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog",
                    "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog\u003c/a\u003e\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "attachments": [
                        {
                            "type": "video",
                            "author_name": "GIPHY",
                            "title": "Moustache Thumbs Up GIF - Find \u0026 Share on GIPHY",
                            "title_link": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "text": "Discover \u0026 share this Pouce Leve GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.",
                            "image_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "thumb_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.gif",
                            "asset_url": "https://media.giphy.com/media/73Sjhw0N4hyog/giphy.mp4",
                            "og_scrape_url": "https://giphy.com/gifs/beard-muscle-73Sjhw0N4hyog"
                        }
                    ],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 0,
                    "created_at": "2020-01-28T22:17:31.155428Z",
                    "updated_at": "2020-01-28T22:17:31.155428Z",
                    "mentioned_users": []
                },
                {
                    "id": "5c7d0c68-72d5-4027-b6b7-711b342d0fc4",
                    "text": "The carbons could be said to resemble smartish hoods.",
                    "html": "\u003cp\u003eThe carbons could be said to resemble smartish hoods.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.157811Z",
                    "updated_at": "2020-01-28T22:17:31.157811Z",
                    "mentioned_users": []
                },
                {
                    "id": "5b02535a-0c3c-45fa-9cf8-16f840c5123f",
                    "text": "Their software was, in this moment, a prolix feature.",
                    "html": "\u003cp\u003eTheir software was, in this moment, a prolix feature.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.158391Z",
                    "updated_at": "2020-01-28T22:17:31.158391Z",
                    "mentioned_users": []
                }
            ],
            "watcher_count": 1,
            "read": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "last_read": "2020-01-28T22:17:31.016937728Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "last_read": "2020-01-28T22:17:31.018856448Z"
                }
            ],
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ]
        }
      ''';
      final response = ChannelStateResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.watcherCount, isA<int>());
      expect(response.members, isA<List<Member>>());
      expect(response.messages, isA<List<Message>>());
      expect(response.read, isA<List<Read>>());
    });

    test('QueryUsersResponse', () {
      const jsonExample = r'''
      {"users":[{"id":"wild-breeze-7","role":"user","created_at":"2020-01-12T12:03:19.102029Z","updated_at":"2020-02-03T08:58:33.971562Z","last_active":"2020-02-03T08:58:33.965072Z","banned":false,"online":true,"name":"Wild breeze","image":"https://getstream.io/random_svg/?id=wild-breeze-7\u0026amp;name=Wild+breeze"}],"duration":"2.44ms"}
      ''';
      final response = QueryUsersResponse.fromJson(json.decode(jsonExample));
      expect(response.users, isA<List<User>>());
    });

    test('QueryReactionsResponse', () {
      const jsonExample = r'''
      {"reactions": [{"message_id": "4637f7e4-a06b-42db-ba5a-8d8270dd926f","user_id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680","user": {"id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680","role": "user","created_at": "2020-01-28T22:17:30.83015Z","updated_at": "2020-01-28T22:17:31.19435Z","banned": false,"online": false,"image": "https://randomuser.me/api/portraits/women/2.jpg","name": "Mia Denys"},"type": "love","score": 1,"created_at": "2020-01-28T22:17:31.128376Z","updated_at": "2020-01-28T22:17:31.128376Z"}]}
      ''';
      final response =
          QueryReactionsResponse.fromJson(json.decode(jsonExample));
      expect(response.reactions, isA<List<Reaction>>());
    });

    test('QueryRepliesResponse', () {
      const jsonExample = r'''
      { "messages": [
          {
              "id": "9db3ef01-e779-4279-8c54-ffd021eccec4",
              "text": "A lustred seal is an alto of the mind.",
              "html": "\u003cp\u003eA lustred seal is an alto of the mind.\u003c/p\u003e\n",
              "type": "regular",
              "user": {
                  "id": "spring-voice-7",
                  "role": "user",
                  "created_at": "2020-01-28T22:17:30.834135Z",
                  "updated_at": "2020-01-28T22:17:31.186771Z",
                  "banned": false,
                  "online": false,
                  "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                  "name": "Spring voice"
              },
              "attachments": [],
              "latest_reactions": [],
              "own_reactions": [],
              "reaction_counts": {},
              "reaction_scores": {},
              "reply_count": 0,
              "created_at": "2020-01-28T22:17:31.167579Z",
              "updated_at": "2020-01-28T22:17:31.167579Z",
              "mentioned_users": []
          },
          {
              "id": "3232e92f-a96f-4b5e-bacb-3565e7155dc4",
              "text": "https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS",
              "html": "\u003cp\u003e\u003ca href=\"https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS\" rel=\"nofollow\"\u003ehttps://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS\u003c/a\u003e\u003c/p\u003e\n",
              "type": "regular",
              "user": {
                  "id": "spring-voice-7",
                  "role": "user",
                  "created_at": "2020-01-28T22:17:30.834135Z",
                  "updated_at": "2020-01-28T22:17:31.186771Z",
                  "banned": false,
                  "online": false,
                  "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                  "name": "Spring voice"
              },
              "attachments": [
                  {
                      "type": "video",
                      "author_name": "GIPHY",
                      "title": "The Punisher Marvel GIF by NETFLIX - Find \u0026 Share on GIPHY",
                      "title_link": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                      "text": "See What's Next in entertainment and Netflix original series, movies, TV, docs, and comedies. You can stream Netflix anytime, anywhere, on any device.",
                      "image_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                      "thumb_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.gif",
                      "asset_url": "https://media.giphy.com/media/l3mZsRS7ZfftbdLdS/giphy.mp4",
                      "og_scrape_url": "https://giphy.com/gifs/netflix-marvel-the-punisher-l3mZsRS7ZfftbdLdS"
                  }
              ],
              "latest_reactions": [],
              "own_reactions": [],
              "reaction_counts": {},
              "reaction_scores": {},
              "reply_count": 1,
              "created_at": "2020-01-28T22:17:31.168454Z",
              "updated_at": "2020-01-28T22:17:31.168454Z",
              "mentioned_users": []
          }
      ]}
      ''';
      final response = QueryRepliesResponse.fromJson(json.decode(jsonExample));
      expect(response.messages, isA<List<Message>>());
    });

    test('SearchMessagesResponse', () {
      const jsonExample = r'''
      { "results": [
          {
            "message": {
              "id": "9db3ef01-e779-4279-8c54-ffd021eccec4",
              "text": "A lustred seal is an alto of the mind.",
              "html": "\u003cp\u003eA lustred seal is an alto of the mind.\u003c/p\u003e\n",
              "type": "regular",
              "user": {
                  "id": "spring-voice-7",
                  "role": "user",
                  "created_at": "2020-01-28T22:17:30.834135Z",
                  "updated_at": "2020-01-28T22:17:31.186771Z",
                  "banned": false,
                  "online": false,
                  "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                  "name": "Spring voice"
              },
              "attachments": [],
              "latest_reactions": [],
              "own_reactions": [],
              "reaction_counts": {},
              "reaction_scores": {},
              "reply_count": 0,
              "created_at": "2020-01-28T22:17:31.167579Z",
              "updated_at": "2020-01-28T22:17:31.167579Z",
              "mentioned_users": []
          }
          }]
          }
      ''';
      final response =
          SearchMessagesResponse.fromJson(json.decode(jsonExample));
      expect(response.results, isA<List<GetMessageResponse>>());
    });

    test('ListDevicesResponse', () {
      const jsonExample =
          r'''{"devices":[{"push_provider":"firebase","id":"test"}],"duration":"0.35ms"}''';
      final response = ListDevicesResponse.fromJson(json.decode(jsonExample));
      expect(response.devices, isA<List<Device>>());
    });

    test('SendFileResponse', () {
      const jsonExample = r'''{"file": "file-url","duration":"0.35ms"}''';
      final response = SendFileResponse.fromJson(json.decode(jsonExample));
      expect(response.file, isA<String>());
    });

    test('SendImageResponse', () {
      const jsonExample = r'''{"file": "file-url","duration":"0.35ms"}''';
      final response = SendImageResponse.fromJson(json.decode(jsonExample));
      expect(response.file, isA<String>());
    });

    test('SendImageResponse', () {
      const jsonExample = r'''{"file": "file-url","duration":"0.35ms"}''';
      final response = SendImageResponse.fromJson(json.decode(jsonExample));
      expect(response.file, isA<String>());
    });

    test('EmptyResponse', () {
      const jsonExample = r'''{"file": "file-url","duration":"0.35ms"}''';
      final response = EmptyResponse.fromJson(json.decode(jsonExample));
      expect(response.duration, isA<String>());
    });

    test('SendReactionResponse', () {
      const jsonExample = r'''{"message": {
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
                "reaction":{
                            "message_id": "c74784e7-07ef-4b41-a8e3-b2b0e0b6b7ce",
                            "user_id": "spring-voice-7",
                            "user": {
                                "id": "spring-voice-7",
                                "role": "user",
                                "created_at": "2020-01-28T22:17:30.834135Z",
                                "updated_at": "2020-01-28T22:17:31.186771Z",
                                "banned": false,
                                "online": false,
                                "name": "Spring voice",
                                "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice"
                            },
                            "type": "sad",
                            "score": 1,
                            "created_at": "2020-01-28T22:17:31.131489Z",
                            "updated_at": "2020-01-28T22:17:31.131489Z"
                        },"duration":"0.35ms"}''';
      final response = SendReactionResponse.fromJson(json.decode(jsonExample));
      expect(response.message, isA<Message>());
      expect(response.reaction, isA<Reaction>());
    });

    test('UpdateUsersResponse', () {
      const jsonExample =
          r'''{"users": {"bbb19d9a-ee50-45bc-84e5-0584e79d0c9e":{
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    }},"duration":"0.35ms"}''';
      final response = UpdateUsersResponse.fromJson(json.decode(jsonExample));
      expect(response.users, isA<Map<String, User>>());
    });

    test('SetGuestUserResponse', () {
      const jsonExample =
          r'{"user":{"id":"guest-ac612aee-25fe-49fb-b1af-969e41f452a0-wild-breeze-7","role":"guest","created_at":"2020-02-03T10:19:01.538434Z","updated_at":"2020-02-03T10:19:01.539543Z","banned":false,"online":false},"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ3Vlc3QtYWM2MTJhZWUtMjVmZS00OWZiLWIxYWYtOTY5ZTQxZjQ1MmEwLXdpbGQtYnJlZXplLTcifQ.mmoFGu7oJjpFsp7nFN78UbIpO7gowbuIbyoppsuvbXA","duration":"4.66ms"}';
      final response = SetGuestUserResponse.fromJson(json.decode(jsonExample));
      expect(response.user, isA<User>());
      expect(response.accessToken, isA<String>());
    });

    test('GetMessagesByIdResponse', () {
      const jsonExample = r'''{"messages":[{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                }],"duration":"4.66ms"}''';
      final response =
          GetMessagesByIdResponse.fromJson(json.decode(jsonExample));
      expect(response.messages, isA<List<Message>>());
    });

    test('SendActionResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },"duration":"4.66ms"}''';
      final response = SendActionResponse.fromJson(json.decode(jsonExample));
      expect(response.message, isA<Message>());
    });

    test('UpdateMessageResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },"duration":"4.66ms"}''';
      final response = UpdateMessageResponse.fromJson(json.decode(jsonExample));
      expect(response.message, isA<Message>());
    });

    test('SendMessageResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },"duration":"4.66ms"}''';
      final response = SendMessageResponse.fromJson(json.decode(jsonExample));
      expect(response.message, isA<Message>());
    });

    test('GetMessageResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },"duration":"4.66ms"}''';
      final response = GetMessageResponse.fromJson(json.decode(jsonExample));
      expect(response.message, isA<Message>());
    });

    test('UpdateChannelResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = UpdateChannelResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });

    test('InviteMembersResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = InviteMembersResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });

    test('RemoveMembersResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = RemoveMembersResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });

    test('AddMembersResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = AddMembersResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });

    test('AcceptInviteResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = AcceptInviteResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });

    test('RejectInviteResponse', () {
      const jsonExample = r'''{"message":{
                    "id": "c6076f11-7768-4a04-bdf2-c43dddd6d666",
                    "text": "What we don't know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.",
                    "html": "\u003cp\u003eWhat we don’t know for sure is whether or not a step-daughter of the bear is assumed to be a farci hourglass.\u003c/p\u003e\n",
                    "type": "regular",
                    "user": {
                        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.826259Z",
                        "updated_at": "2020-01-28T22:17:31.101222Z",
                        "banned": false,
                        "online": false,
                        "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg",
                        "name": "Robin Papa"
                    },
                    "attachments": [],
                    "latest_reactions": [],
                    "own_reactions": [],
                    "reaction_counts": {},
                    "reaction_scores": {},
                    "reply_count": 1,
                    "created_at": "2020-01-28T22:17:31.092262Z",
                    "updated_at": "2020-01-28T22:17:31.092262Z",
                    "mentioned_users": []
                },
            "members": [
                {
                    "user": {
                        "id": "c1c9b454-2bcc-402d-8bb0-2f3706ce1680",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.83015Z",
                        "updated_at": "2020-01-28T22:17:31.19435Z",
                        "banned": false,
                        "online": false,
                        "image": "https://randomuser.me/api/portraits/women/2.jpg",
                        "name": "Mia Denys"
                    },
                    "role": "member",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                },
                {
                    "user": {
                        "id": "spring-voice-7",
                        "role": "user",
                        "created_at": "2020-01-28T22:17:30.834135Z",
                        "updated_at": "2020-01-28T22:17:31.186771Z",
                        "banned": false,
                        "online": false,
                        "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                        "name": "Spring voice"
                    },
                    "role": "owner",
                    "created_at": "2020-01-28T22:17:31.005135Z",
                    "updated_at": "2020-01-28T22:17:31.005135Z"
                }
            ],
            "channel": {
                "id": "!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "type": "messaging",
                "cid": "messaging:!members-0LOcD0mZtTan60zHobLmELjdndXsonnBVNzZnB5mTt0",
                "last_message_at": "2020-01-28T22:17:31.204287Z",
                "created_at": "2020-01-28T22:17:31.00187Z",
                "updated_at": "2020-01-28T22:17:31.00187Z",
                "created_by": {
                    "id": "spring-voice-7",
                    "role": "user",
                    "created_at": "2020-01-28T22:17:30.834135Z",
                    "updated_at": "2020-01-28T22:17:31.186771Z",
                    "banned": false,
                    "online": false,
                    "image": "https://getstream.io/random_svg/?id=spring-voice-7\u0026name=Spring+voice",
                    "name": "Spring voice"
                },
                "frozen": false,
                "member_count": 2,
                "config": {
                    "created_at": "2020-01-29T12:59:14.291912835Z",
                    "updated_at": "2020-01-29T12:59:14.291912991Z",
                    "name": "messaging",
                    "typing_events": true,
                    "read_events": true,
                    "connect_events": true,
                    "search": true,
                    "reactions": true,
                    "replies": true,
                    "mutes": true,
                    "uploads": true,
                    "url_enrichment": true,
                    "message_retention": "infinite",
                    "max_message_length": 5000,
                    "automod": "disabled",
                    "automod_behavior": "flag",
                    "commands": [
                        {
                            "name": "giphy",
                            "description": "Post a random gif to the channel",
                            "args": "[text]",
                            "set": "fun_set"
                        }
                    ]
                },
                "name": "Mia Denys",
                "image": "https://randomuser.me/api/portraits/women/2.jpg"
            },
                "duration":"4.66ms"}''';
      final response = RejectInviteResponse.fromJson(json.decode(jsonExample));
      expect(response.channel, isA<ChannelModel>());
      expect(response.members, isA<List<Member>>());
      expect(response.message, isA<Message>());
    });
  });
}
