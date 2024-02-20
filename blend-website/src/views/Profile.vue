<template>
	<div id="profilePage">
		<Parallax
			:image="{
				backgroundImage: `url(${require('@/assets/img/Background.jpg')})`,
				'background-position': 'center',
			}"
			:height="'100vh'"
			:opacity="0.5"
			:overlayColor="'25, 25, 25'"
		>
			<div class="blur">
				<SkewBox
					:height="Math.max(windowHeight, 600)"
					:padding="'0 0 0 0'"
					:divisionPosition="40"
					:leftColor="'linear-gradient(to bottom, var(--top), rgba(var(--bottom), 0.5) 60%, transparent); backdrop-filter: blur(1.5px)'"
					:rightColor="'transparent'"
					:maintainSkewbox="false"
					:pictureSide="'right'"
					:mobileColor="'linear-gradient(to bottom, var(--top), rgba(var(--bottom), 0.5) 60%, transparent)'"
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
												<h5>42M</h5>
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
												<h5>5</h5>
												<h6>Following</h6>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</template>
					<template v-slot:right>
						<div
							class="vertical-center"
							style="transform: translateY(-2rem)"
						>
							<Quote :author="'- ' + workspace.name">{{
								workspace.bio
							}}</Quote>
						</div>
					</template>
				</SkewBox>

				<div class="mx-s-5 py-5">
					<div class="container white">
                        <SocialLink :platform="'discord'" :link="'https://www.example.com/'" :title="'discord'"></SocialLink>
                        <SocialLink :platform="'douyin'" :link="'https://www.example.com/'" :title="'douyin'"></SocialLink>
                        <SocialLink :platform="'facebook'" :link="'https://www.example.com/'" :title="'facebook'"></SocialLink>
                        <SocialLink :platform="'instagram'" :link="'https://www.example.com/'" :title="'instagram'"></SocialLink>
                        <SocialLink :platform="'linkedin'" :link="'https://www.example.com/'" :title="'linkedin'"></SocialLink>
                        <SocialLink :platform="'messenger'" :link="'https://www.example.com/'" :title="'messenger'"></SocialLink>
                        <SocialLink :platform="'pinterest'" :link="'https://www.example.com/'" :title="'pinterest'"></SocialLink>
                        <SocialLink :platform="'quora'" :link="'https://www.example.com/'" :title="'quora'"></SocialLink>
                        <SocialLink :platform="'reddit'" :link="'https://www.example.com/'" :title="'reddit'"></SocialLink>
                        <SocialLink :platform="'skype'" :link="'https://www.example.com/'" :title="'skype'"></SocialLink>
                        <SocialLink :platform="'snapchat'" :link="'https://www.example.com/'" :title="'snapchat'"></SocialLink>
                        <SocialLink :platform="'telegram'" :link="'https://www.example.com/'" :title="'telegram'"></SocialLink>
                        <SocialLink :platform="'threads'" :link="'https://www.example.com/'" :title="'threads'"></SocialLink>
                        <SocialLink :platform="'tiktok'" :link="'https://www.example.com/'" :title="'tiktok'"></SocialLink>
                        <SocialLink :platform="'tumblr'" :link="'https://www.example.com/'" :title="'tumblr'"></SocialLink>
                        <SocialLink :platform="'twitch'" :link="'https://www.example.com/'" :title="'twitch'"></SocialLink>
                        <SocialLink :platform="'wechat'" :link="'https://www.example.com/'" :title="'wechat'"></SocialLink>
                        <SocialLink :platform="'whatsapp'" :link="'https://www.example.com/'" :title="'whatsapp'"></SocialLink>
                        <SocialLink :platform="'x'" :link="'https://www.example.com/'" :title="'x'"></SocialLink>
                        <SocialLink :platform="'youtube'" :link="'https://www.example.com/'" :title="'youtube'"></SocialLink>
                        <SocialLink :platform="'github'" :link="'https://www.example.com/'" :title="'github'"></SocialLink>
                        <SocialLink :platform="'myspace'" :link="'https://www.example.com/'" :title="'myspace'"></SocialLink>
                        <SocialLink :platform="'researchgate'" :link="'https://www.example.com/'" :title="'researchgate'"></SocialLink>
                        <SocialLink :platform="'soundcloud'" :link="'https://www.example.com/'" :title="'soundcloud'"></SocialLink>
                        <SocialLink :platform="'stackoverflow'" :link="'https://www.example.com/'" :title="'stackoverflow'"></SocialLink>
                        <SocialLink :platform="'steam'" :link="'https://www.example.com/'" :title="'steam'"></SocialLink>
                        <SocialLink :platform="'spotify'" :link="'https://www.example.com/'" :title="'spotify'"></SocialLink>
                    </div>
				</div>
			</div>
		</Parallax>
	</div>
</template>

<script>
import SkewBox from "@/components/SkewBox.vue";
import Parallax from "@/components/Parallax.vue";
import Quote from "@/components/Quote.vue";
import SocialLink from '@/components/SocialLink.vue';

export default {
	components: {
		SkewBox,
		Parallax,
		Quote,
        SocialLink,
	},
	data() {
		return {
			workspace: {
				pfp: "https://www.w3schools.com/w3images/avatar2.png",
				name: "John Doe",
				email: "jdoe@example.com",
				phone: "123-456-7890",
				bio: "As educators, we care, and we are deeply passionate about student-engaged learning. My teaching philosophy is to exude this, to truly live out this care, passion, and dedication, which inevitably serves to motivate, to inspire, and to awaken in students a sincere interest in learning. While effective transmission of knowledge is arguably a key ingredient in successful teaching, my goal is to guide and inspire students to discover their goals, their purpose, and their potential.",
			},
			windowHeight: 0,
			windowWidth: 0,
		};
	},
	methods: {
		getWindowSize() {
			this.windowHeight = window.innerHeight;
			this.windowWidth = window.innerWidth;
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
	},
};
</script>

<style scoped>
#profilePage {
	--top: rgb(255, 149, 56);
	--bottom: 114, 203, 255;
}
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
</style>