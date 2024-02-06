module.exports = {
    plugins: [
        [
            '@docusaurus/plugin-content-docs',
            {
                lastVersion: 'current',
                versions: {
                    current: {
                        label: 'v7'
                    },
                    '3.x.x': {
                        label: 'v3',
                        path: 'v3'
                    },
                    '4.x.x': {
                        label: 'v4',
                        path: 'v4'
                    },
                    '5.x.x': {
                        label: 'v5',
                        path: 'v5'
                    }
                }
            }
        ]
    ]
}
