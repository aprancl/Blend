<template>
	<div class="container py-2">
		<a
			style="
				width: 100%;
				height: 5rem;
				max-width: 50rem;
				margin: auto;
				border-radius: 1rem;
				display: flex;
				align-items: center;
				justify-content: center;
				color: white;
				text-decoration: none;
			"
			:style="backgroundStyle"
			:href="link"
			target="_blank"
		>
			<div>{{ title }}</div>
		</a>
	</div>
</template>

<script>
export default {
	props: {
		platform: {
			type: String,
			required: true,
		},
		link: {
			type: String,
			required: true,
		},
		title: {
			type: String,
			required: true,
		},
	},
	data() {
		return {
			backgroundStyle: "",
		};
	},
	methods: {
		setLinkBackground() {
			console.log("IM HERE");
			switch (this.platform) {
				case "discord":
					this.backgroundStyle = this.generateStyle([
						"#7289da",
						"#ffffff",
					]);
					break;
				case "douyin":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#00f2ea",
						"#ff0050",
					]);
					break;
				case "facebook":
					this.backgroundStyle = this.generateStyle([
						"#1877F2",
						"#ffffff",
					]);
					break;
				case "instagram":
					this.backgroundStyle = this.generateStyle([
						"#515BD4",
						"#8134AF",
						"#DD2A7B",
						"#FEDA77",
						"#F58529",
					]);
					break;
				case "linkedin":
					this.backgroundStyle = this.generateStyle([
						"#0077b5",
						"#ffffff",
					]);
					break;
				case "messenger":
					this.backgroundStyle = this.generateStyle([
						"#006AFF",
						"#00B2FF",
						"#FFFFFF",
					]);
					break;
				case "pinterest":
					this.backgroundStyle = this.generateStyle([
						"#E60023",
						"#ffffff",
					]);
					break;
				case "quora":
					this.backgroundStyle = this.generateStyle([
						"#aa2200",
						"#ffffff",
					]);
					break;
				case "reddit":
					this.backgroundStyle = this.generateStyle([
						"#FF4500",
						"#ffffff",
					]);
					break;
				case "skype":
					this.backgroundStyle = this.generateStyle([
						"#00aff0",
						"#ffffff",
					]);
					break;
				case "snapchat":
					this.backgroundStyle = this.generateStyle([
						"#FFFC00",
						"#ffffff",
						"#000000",
					]);
					break;
				case "telegram":
					this.backgroundStyle = this.generateStyle([
						"#0088cc",
						"#ffffff",
					]);
					break;
				case "threads":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#ffffff",
					]);
					break;
				case "tiktok":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#00f2ea",
						"#ff0050",
					]);
					break;
				case "tumblr":
					this.backgroundStyle = this.generateStyle([
						"#34526f",
						"#ffffff",
					]);
					break;
				case "twitch":
					this.backgroundStyle = this.generateStyle([
						"#6441a5",
						"#ffffff",
					]);
					break;
				case "wechat":
					this.backgroundStyle = this.generateStyle([
						"#09B83E",
						"#ffffff",
					]);
					break;
				case "whatsapp":
					this.backgroundStyle = this.generateStyle([
						"#25d366",
						"#ffffff",
					]);
					break;
				case "x":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#ffffff",
					]);
					break;
				case "youtube":
					this.backgroundStyle = this.generateStyle([
						"#ff0000",
						"#ffffff",
						"#282828",
					]);
					break;
				case "github":
					this.backgroundStyle = this.generateStyle([
						"#152d3c",
						"#ffffff",
					]);
					break;
				case "myspace":
					this.backgroundStyle = this.generateStyle([
						"#08399c",
						"#ffffff",
					]);
					break;
				case "researchgate":
					this.backgroundStyle = this.generateStyle([
						"#08d7bf",
						"#ffffff",
					]);
					break;
				case "soundcloud":
					this.backgroundStyle = this.generateStyle([
						"#f36829",
						"#f78925",
						"#ffffff",
					]);
					break;
				case "stackoverflow":
					this.backgroundStyle = this.generateStyle([
						"#f4842a",
						"#bebdbd",
						"#ffffff",
					]);
					break;
				case "steam":
					this.backgroundStyle = this.generateStyle([
						"#1c1f2d",
						"#12224d",
						"#1c5487",
						"#118dba",
						"#ffffff",
					]);
					break;
				case "spotify":
					this.backgroundStyle = this.generateStyle([
						"#25d865",
						"#ffffff",
						"#000000",
					]);
					break;
			}
		},

		generateStyle(colors) {
			if (colors.length === 1) {
				return `background: ${colors[0]};`;
			} else if (colors.length == 2) {
				return `background: linear-gradient(60deg, ${colors[0]} 70%, ${colors[1]} 80%, ${colors[0]} 90%);`;
			} else if (colors.length == 3) {
				return `background: linear-gradient(60deg, ${colors[0]} 70%, ${colors[1]} 80%, ${colors[2]} 90%);`;
			} else {
				var s = "background: linear-gradient(60deg, ";
				for (let i = 0; i < colors.length - 1; i++) {
					s += `${colors[i]}, `;
				}
				s += `${colors[colors.length - 1]};`;
				return s;
			}
		},
	},
	mounted() {
		this.setLinkBackground();
	},
};
</script>

<style>
</style>