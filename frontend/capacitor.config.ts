import type { CapacitorConfig } from '@capacitor/cli';

const devConfig: CapacitorConfig['server'] = {
	url: 'http://192.168.1.185:5173',
	cleartext: true
};

const config: CapacitorConfig = {
	appId: 'lk.cloudparallax.veli',
	appName: 'Veḷi',
	webDir: 'build',
	server: {
		androidScheme: 'http',
		...(process.env.CAPACITOR_LIVE_RELOAD === '1' ? devConfig : {})
	},
	plugins: {
		SplashScreen: {
			launchAutoHide: false,
			backgroundColor: '#1B3A5C'
		}
	}
};

export default config;
