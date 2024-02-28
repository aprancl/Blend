<template>
	<div id="profilePage" v-if="workspace && blendCard">
		<Parallax
			:image="{
				backgroundImage: `url(${blendCard.background})`,
				'background-position': 'center',
			}"
			:height="'100vh'"
			:opacity="0.5"
			:overlayColor="'25, 25, 25'"
		>
			<div class="blur">
				<SkewBox
					:style="(windowWidth >= 1200) ? 'position: fixed' : ''"
                    class="w-100"
					:height="Math.max(windowHeight, 600)"
					:padding="'0 0 0 0'"
					:divisionPosition="40"
					:leftColor="'linear-gradient(to bottom, var(--top), var(--bottom) 60%, transparent); backdrop-filter: blur(1.5px)'"
					:rightColor="'transparent'"
					:maintainSkewbox="false"
					:pictureSide="'right'"
					:mobileColor="'linear-gradient(to bottom, var(--top), var(--bottom) 60%, transparent)'"
				>
					<template v-slot:left>
						<div class="pb-5 h-100">
							<div class="vertical-center">
								<div class="workspacePic mb-3 mt-5 mt-xl-3">
									<img
										:src="workspace.pfp"
										alt=""
										class="workspacePic"
									/>
								</div>
								<div class="w-100">
									<center>
										<h1 class="white">
											{{ workspace.name }}
										</h1>
									</center>
								</div>
								<hr class="w-75 mx-auto white-hr" />
								<div class="white">
									<div class="w-75 mx-auto row">
										<div
											class="col-6"
											style="
												display: flex;
												flex-direction: column;
												align-items: flex-end;
											"
										>
											<div class="pe-3">
												<h5>
													{{
														convertToReadableValue(
															workspace.followers
														)
													}}
												</h5>
												<h6>Followers</h6>
											</div>
										</div>
										<div
											class="col-6"
											style="
												display: flex;
												flex-direction: column;
												align-items: flex-start;
											"
										>
											<div class="ps-3">
												<h5>
													{{
														convertToReadableValue(
															workspace.following
														)
													}}
												</h5>
												<h6>Following</h6>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</template>
					<template v-slot:right>
						<div class="right">
							<div
							>
								<Quote class="ps-1 ps-xl-0" :author="'- ' + workspace.name">{{
									blendCard.bio
								}}</Quote>
							</div>
							<div class="mx-s-5 py-2">
								<div class="row white w-100 mx-auto">
									<SocialLink
										v-for="platform in blendCard.platforms"
										class="col-md-6 col-12"
										:key="platform"
										:platform="platform.type"
										:link="platform.type == 'email' ? `mailto:${platform.url}` : (platform.url.startsWith('http://') || platform.url.startsWith('https://') ? platform.url : `https://${platform.url}`)"
										:title="platform.title"
									></SocialLink>
								</div>
							</div>
						</div>
					</template>
				</SkewBox>
			</div>
		</Parallax>
	</div>
</template>

<script>
import SkewBox from "@/components/SkewBox.vue";
import Parallax from "@/components/Parallax.vue";
import Quote from "@/components/Quote.vue";
import SocialLink from "@/components/SocialLink.vue";

export default {
	components: {
		SkewBox,
		Parallax,
		Quote,
		SocialLink,
	},
	data() {
		return {
			workspace: null,
			blendCard: null,
			windowHeight: 0,
			windowWidth: 0,
		};
	},
	methods: {
		getWindowSize() {
			this.windowHeight = window.innerHeight;
			this.windowWidth = window.innerWidth;
		},
		convertToReadableValue(value) {
			if (value >= 1000000000) {
				return (
					(value / 1000000000)
						.toFixed(1)
						.substring(
							0,
							(value / 1000000000).toFixed(1).indexOf(".")
						) + "B"
				);
			} else if (value >= 1000000) {
				return (
					(value / 1000000)
						.toFixed(1)
						.substring(
							0,
							(value / 1000000).toFixed(1).indexOf(".")
						) + "M"
				);
			} else if (value >= 1000) {
				return (
					(value / 1000)
						.toFixed(1)
						.substring(0, (value / 1000).toFixed(1).indexOf(".")) +
					"K"
				);
			} else {
				return value;
			}
		},
	},
	created() {
		window.addEventListener("resize", this.getWindowSize);
	},
	destroyed() {
		window.removeEventListener("resize", this.getWindowSize);
	},
	async beforeMount() {
		this.getWindowSize();

		// Get workspaceID from the URL
		const workspaceID = this.$route.params.id;

		console.log("Workspace ID: ", workspaceID);

		// Fetch workspace from db
		await this.$store.dispatch("fetchWorkspace", workspaceID);

		// Set the workspace data
		this.workspace = this.$store.getters.workspace;
		this.blendCard = this.$store.getters.blendCard;
		var page = document.querySelector(":root");
		page.style.setProperty("--top", this.blendCard.topColor);
		page.style.setProperty("--bottom", this.blendCard.bottomColor);
	},
};
</script>

<style scoped>
.white-hr {
	margin: 0 0 15px 0;
	border-bottom: 4px solid white;
	border-radius: 20px;
	opacity: 1;
}

.vertical-center {
	display: flex;
	align-items: center;
	height: 100%;
	width: 100%;
	justify-content: center;
	flex-direction: column;
}

.white {
	color: white;
}

.customRow {
	display: flex;
	flex-direction: row;
	margin: auto;
}

.customRow .left {
	width: fit-content !important;
}

.workspacePic {
	height: 250px;
	width: 250px;
	background-color: white;
	border-radius: 50%;
	margin: auto;
}

img.workspacePic {
	border: 5px solid grey;
}

.right {
	overflow-y: scroll;
    overflow-x: visible;
	height: 100%;
	-ms-overflow-style: none;
	scrollbar-width: none;
    padding-left: 1rem;
    transform: translateX(1rem);
}
.right::-webkit-scrollbar {
	display: none;
}

:deep(.poly-content.poly-right) {
    padding-top: 0;
    padding-bottom: 2.5rem;
}

/* media query for when screen is udner 1200px wide */
@media (max-width: 1200px) {
    .right {
        padding-left: 0;
        transform: translateX(0);
    }
}
</style>