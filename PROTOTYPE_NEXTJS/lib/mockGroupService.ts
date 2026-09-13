/** Mirrors group-sync-api-contract.md */

export type Proposal = { id: string; title: string; votes: number; total_voters: number };

let proposals: Proposal[] = [
  { id: "prop_01", title: "Sintra day trip", votes: 3, total_voters: 4 },
  { id: "prop_02", title: "Beach day — Cascais", votes: 1, total_voters: 4 },
  { id: "prop_03", title: "Free exploring", votes: 2, total_voters: 4 },
];
let yourVote: string | null = "prop_01";

export async function fetchProposals(): Promise<{ proposals: Proposal[]; your_vote: string | null }> {
  await new Promise((r) => setTimeout(r, 300));
  return { proposals, your_vote: yourVote };
}

export async function castVote(proposalId: string) {
  await new Promise((r) => setTimeout(r, 250));
  if (yourVote) {
    proposals = proposals.map((p) => (p.id === yourVote ? { ...p, votes: p.votes - 1 } : p));
  }
  proposals = proposals.map((p) => (p.id === proposalId ? { ...p, votes: p.votes + 1 } : p));
  yourVote = proposalId;
  return { proposals, your_vote: yourVote };
}

export type CompromiseResult = {
  majority_pick: { title: string; day: number; voter_count: number };
  minority_pick: { title: string; day: number; voter_count: number };
};

export async function fetchCompromise(): Promise<CompromiseResult> {
  await new Promise((r) => setTimeout(r, 400));
  return {
    majority_pick: { title: "Sintra day trip", day: 3, voter_count: 3 },
    minority_pick: { title: "Cascais beach afternoon", day: 5, voter_count: 1 },
  };
}

export type GroupMember = { id: string; name: string; initial: string; is_you: boolean; is_active: boolean };

export async function fetchMembers(): Promise<GroupMember[]> {
  await new Promise((r) => setTimeout(r, 200));
  return [
    { id: "u_01", name: "Maya", initial: "M", is_you: true, is_active: true },
    { id: "u_02", name: "Jake", initial: "J", is_you: false, is_active: true },
    { id: "u_03", name: "Rosa", initial: "R", is_you: false, is_active: false },
  ];
}
