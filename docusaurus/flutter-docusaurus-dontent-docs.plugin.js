module.exports = {
    plugins: [
        [
            '@docusaurus/plugin-content-docs',
            {
                lastVersion: 'current',
                versions: {
                    current: {
                        label: 'v5'
                    },
                    '3.x.x': {
                        label: 'v3',
                        path: 'v3'
                    },
                    '4.x.x': {
                        label: 'v4',
                        path: 'v4'
                    }
                }
            }
        ]
    ]
}
