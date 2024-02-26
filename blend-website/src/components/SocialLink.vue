<template>
	<div class="py-2">
		<a
			style="
				width: 100%;
				height: 5rem;
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
			<div class="row w-100">
				<div class="col-1" id="icon">
					<i :class="icon"></i>
				</div>
				<div class="col-10" id="title">
					<h3>{{ title }}</h3>
				</div>
			</div>
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
			icon: "fa-solid fa-globe",
		};
	},
	methods: {
		formatLink() {
			console.log("IM HERE");
			switch (this.platform) {
				case "discord":
					this.backgroundStyle = this.generateStyle([
						"#5865F2",
						"#ffffff",
					]);
					this.icon = "fab fa-discord";
					break;
				case "douyin":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#00f2ea",
						"#ff0050",
					]);
					this.icon = "fab fa-tiktok";
					break;
				case "facebook":
					this.backgroundStyle = this.generateStyle([
						"#1877F2",
						"#ffffff",
					]);
					this.icon = "fab fa-facebook";
					break;
				case "instagram":
					this.backgroundStyle = this.generateStyle([
						"#515BD4",
						"#8134AF",
						"#DD2A7B",
						"#FEDA77",
						"#F58529",
					]);
					this.icon = "fab fa-instagram";
					break;
				case "linkedin":
					this.backgroundStyle = this.generateStyle([
						"#0077b5",
						"#ffffff",
					]);
					this.icon = "fab fa-linkedin";
					break;
				case "messenger":
					this.backgroundStyle = this.generateStyle([
						"#006AFF",
						"#00B2FF",
						"#FFFFFF",
					]);
					this.icon = "fab fa-facebook-messenger";
					break;
				case "pinterest":
					this.backgroundStyle = this.generateStyle([
						"#E60023",
						"#ffffff",
					]);
					this.icon = "fab fa-pinterest";
					break;
				case "quora":
					this.backgroundStyle = this.generateStyle([
						"#aa2200",
						"#ffffff",
					]);
					this.icon = "fab fa-quora";
					break;
				case "reddit":
					this.backgroundStyle = this.generateStyle([
						"#FF4500",
						"#ffffff",
					]);
					this.icon = "fab fa-reddit";
					break;
				case "skype":
					this.backgroundStyle = this.generateStyle([
						"#00aff0",
						"#ffffff",
					]);
					this.icon = "fab fa-skype";
					break;
				case "snapchat":
					this.backgroundStyle =
						this.generateStyle(["#FFFC00", "#ffffff", "#000000"]) +
						" color: black!important;";
					this.icon = "fab fa-snapchat-ghost";
					break;
				case "telegram":
					this.backgroundStyle = this.generateStyle([
						"#0088cc",
						"#ffffff",
					]);
                    this.icon = "fab fa-telegram";
					break;
				case "threads":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#ffffff",
					]);
                    this.icon = "fab fa-threads";
					break;
				case "tiktok":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#00f2ea",
						"#ff0050",
					]);
                    this.icon = "fab fa-tiktok";
					break;
				case "tumblr":
					this.backgroundStyle = this.generateStyle([
						"#34526f",
						"#ffffff",
					]);
                    this.icon = "fab fa-tumblr";
					break;
				case "twitch":
					this.backgroundStyle = this.generateStyle([
						"#6441a5",
						"#ffffff",
					]);
                    this.icon = "fab fa-twitch";
					break;
				case "wechat":
					this.backgroundStyle = this.generateStyle([
						"#09B83E",
						"#ffffff",
					]);
                    this.icon = "fab fa-weixin";
					break;
				case "whatsapp":
					this.backgroundStyle = this.generateStyle([
						"#25d366",
						"#ffffff",
					]);
                    this.icon = "fab fa-whatsapp";
					break;
				case "x":
					this.backgroundStyle = this.generateStyle([
						"#000000",
						"#ffffff",
					]);
                    this.icon = "fab fa-x-twitter";
					break;
				case "youtube":
					this.backgroundStyle = this.generateStyle([
						"#ff0000",
						"#ffffff",
						"#282828",
					]);
                    this.icon = "fab fa-youtube";
					break;
				case "github":
					this.backgroundStyle = this.generateStyle([
						"#152d3c",
						"#ffffff",
					]);
                    this.icon = "fab fa-github";
					break;
				case "researchgate":
					this.backgroundStyle =
						this.generateStyle(["#08d7bf", "#ffffff"]) +
						" color: black!important;";
                    this.icon = "fab fa-researchgate";
					break;
				case "soundcloud":
					this.backgroundStyle = this.generateStyle([
						"#f36829",
						"#f78925",
						"#ffffff",
					]);
                    this.icon = "fab fa-soundcloud";
					break;
				case "stackoverflow":
					this.backgroundStyle =
						this.generateStyle(["#f4842a", "#bebdbd", "#ffffff"]) +
						" color: black!important;";
                        this.icon = "fab fa-stack-overflow";
					break;
				case "steam":
					this.backgroundStyle = this.generateStyle([
						"#1c1f2d",
						"#12224d",
						"#1c5487",
						"#118dba",
						"#ffffff",
					]);
                    this.icon = "fab fa-steam";
					break;
				case "spotify":
					this.backgroundStyle =
						this.generateStyle(["#25d865", "#ffffff", "#000000"]) +
						" color: black!important;";
                    this.icon = "fab fa-spotify";
					break;
				default:
					this.backgroundStyle =
						this.generateStyle(["#ffffff", "#000000"]) +
						" color: black!important;";
                    this.icon = "fa-solid fa-globe";
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
		this.formatLink();
	},
};
</script>

<style scoped>
.row>div {
	font-size: 2rem;
	display: flex;
	align-items: center;
	justify-content: center;
}

#icon {
	display: flex;
	align-items: center;
	justify-content: left;
	padding-left: 1.5rem;
}

h3 {
	margin: 0;
	padding: 0;
}
</style>