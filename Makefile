# ================================================================
# │                 GENERIC MAKEFILE CONFIGURATION               │
# ================================================================
-include .env

.PHONY: all test clean help install snapshot format anvil deploy-anvil deploy-holesky #deploy-mainnet

help:
	@echo "Usage:"
	@echo "  make deploy-anvil\n

clean 		:; forge clean
remove 		:; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"
update 		:; forge update
build 		:; forge build
test 		:; forge test
snapshot 	:; forge snapshot
format 		:; forge fmt

# Configure Anvil
anvil 				:; anvil -m 'test test test test test test test test test test test junk' --steps-tracing #--block-time 1
DEFAULT_ANVIL_KEY 	:= 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Configure Deployment Variables
anvil-network:
	$(eval \
		NETWORK_ARGS := --broadcast \
						--rpc-url http://localhost:8545 \
						--private-key $(DEFAULT_ANVIL_KEY) \
	)

holesky-network: 
	$(eval \
		NETWORK_ARGS := --broadcast \
			--rpc-url $(HOLESKY_RPC_URL) \
			--private-key $(HOLESKY_PRIVATE_KEY) \
			--verify \
			--etherscan-api-key $(ETHERSCAN_API_KEY) \
	)

# mainnet-network: 
# 	$(eval \
# 		NETWORK_ARGS := --broadcast \
# 			--rpc-url $(MAINNET_RPC_URL) \
# 			--private-key $(MAINNET_PRIVATE_KEY) \
# 			--verify \
# 			--etherscan-api-key $(ETHERSCAN_API_KEY) \
# 	)

# ================================================================
# │                CONTRACT SPECIFIC CONFIGURATION               │
# ================================================================
install:
	forge install foundry-rs/forge-std@v1.5.3 --no-commit && \
	forge install Cyfrin/foundry-devops@0.0.11 --no-commit && \
	forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit

deploy-basicNft:
	@forge script script/DeployNft.s.sol:DeployBasicNft $(NETWORK_ARGS) -vvvv

mint-basicNft: 
	@forge script script/Interactions.s.sol:MintBasicNft $(NETWORK_ARGS) -vvvv

return-basicNftUri: 
	@forge script script/Interactions.s.sol:ReturnBasicNftUri $(NETWORK_ARGS) -vvvv

deploy-moodNft:
	@forge script script/DeployNft.s.sol:DeployMoodNft $(NETWORK_ARGS) -vvvv

mint-moodNft: 
	@forge script script/Interactions.s.sol:MintMoodNft $(NETWORK_ARGS) -vvvv

flipMood: 
	@forge script script/Interactions.s.sol:FlipMoodNft $(NETWORK_ARGS) -vvvv


# ================================================================
# │                         RUN COMMANDS                         │
# ================================================================
deploy-anvil-basicNft: anvil-network deploy-basicNft
deploy-holesky-basicNft: holesky-network deploy-basicNft

anvil-mint-basicNft: anvil-network mint-basicNft
holesky-mint-basicNft: holesky-network mint-basicNft

anvil-return-basicNftUri: anvil-network return-basicNftUri
holesky-return-basicNftUri: holesky-network return-basicNftUri


deploy-anvil-moodNft: anvil-network deploy-moodNft
deploy-holesky-moodNft: holesky-network deploy-moodNft

anvil-mint-moodNft: anvil-network mint-moodNft
holesky-mint-moodNft: holesky-network mint-moodNft

anvil-flipMood: anvil-network flipMood
holesky-flipMood: holesky-network flipMood