import React from 'react';
import { Heart } from 'lucide-react';
export function App() {
  return <div className="w-full min-h-screen bg-[#8FBC8F] font-['Times_New_Roman'] text-base text-black">
      <div className="flex flex-col items-center px-4 py-8">
        <div className="overflow-x-auto">
          <img src="https://letslearntogether.neocities.org/RNDTBL/RNDTBLtest01.png" alt="RNDTBL Logo" className="max-w-full max-h-full" />
        </div>
        <div className="mt-4 text-center">
          <p className="text-white font-bold">
            COMMUNICATION AND COLLABORATION
            <br />
            CAN TRANSFORM THE WORLD
          </p>
        </div>
        <div className="mt-4">
          <Heart className="text-[#FF91AF] fill-[#FF91AF]" size={20} />
        </div>
        <div className="w-full mt-8">
          <hr className="border-gray-400" />
        </div>
        <div className="w-full max-w-4xl mt-8 text-white px-4">
          <p className="mb-4">
            • <span className="font-bold">What Is RNDTBL?</span>
          </p>
          <p className="mb-4">
            RNDTBL is a stylization of the word "roundtable," a dialogue where
            everyone is equal. This is the name of a tool that we are developing
            which is intended to assist a group of people in performing in-depth
            collaborative research. This research is aimed at the resolution of
            world problems through the creation of easy to understand,
            step-by-step DIY ecological engineering projects applicable to a
            wide variety of different environments.
          </p>
          <p className="mb-4">
            It operates like a forum in that there are a series of topics that
            act as spaces to dialogue about different aspects of a world
            problem. However, instead of replies being organized within a list,
            they are displayed within a network graph. The more that the people
            within the group interact, the more connections that are made
            between the items that they are contributing. Together, they are
            building up a map of their collective knowledge about these
            subjects!
          </p>
          <div className="flex justify-center my-4">
            <div className="overflow-x-auto">
              <img src="https://letslearntogether.neocities.org/RNDTBL/networkgraph01.png" alt="Network Graph" className="max-w-full max-h-full" />
            </div>
          </div>
          <p className="mb-4">
            Multiple viewpoints can share the same space without one becoming
            "dominant" over another. For example, it wouldn't matter if dialogue
            about one specific topic started to flood the forum as it would all
            be contained within its own "branch" within the network graph,
            existing in parallel to other "branches". In this way, both the
            "pros" and the "cons" of any topic could always be presented
            together. We are attempting to remove the necessity of moderation
            roles by having everyone involved hold each other accountable as
            much as possible, not necessarily by trying to advocate for
            particular viewpoints, but by continually making the consequences of
            individual behaviors plain.
          </p>
          <p className="mb-4">
            By integrating their different viewpoints and showing what they are
            each contributing to the whole, that group of people would then have
            a more comprehensive basis for addressing issues amongst themselves
            and within society in general.
          </p>
          <p className="mb-4">
            Once a problem is well-defined and a promising method of handling it
            is formulated through collaborative research, then tools are
            provided to assist in creating a physical space to test it out,
            refine it, and sustain it on the local level. [See the features of
            the tool, as well as the philosophical and scientific underpinnings
            of its design below.]
          </p>
          <p className="mb-4">
            • <span className="font-bold">What Does The RNDTBL Logo Mean?</span>
          </p>
          <div className="flex justify-center my-4">
            <div className="overflow-x-auto">
              <img src="https://letslearntogether.neocities.org/RNDTBL/mesh01.png" alt="Mesh Network" className="max-w-full max-h-full" />
            </div>
          </div>
          <p className="mb-4">
            The pink hexagram-looking shape is the topology for a "mesh" or
            "fully connected" network. In other words, it represents a group
            where every individual is connected to every other one. It has
            resilience. If one link breaks, everyone can still communicate. The
            shade of pink is my favorite color, Baker-Miller Pink. It is,{' '}
            <a href="https://en.wikipedia.org/wiki/Baker%E2%80%93Miller_pink" target="_blank" rel="noopener noreferrer" className="text-white underline">
              quote
            </a>
            : "...a tone of pink which has been observed to temporarily reduce
            hostile, violent or aggressive behavior." Altogether, this symbol
            represents a communication system in which all people are
            continually interacting in harmony.
          </p>
          <div className="flex justify-center my-4">
            <div className="overflow-x-auto">
              <img src="https://letslearntogether.neocities.org/RNDTBL/branches01.png" alt="Tree Branches" className="max-w-full max-h-full" />
            </div>
          </div>
          <p className="mb-4">
            The tree represents Nature in general. However, the juxtaposition of
            it with the above symbol represents the constructive interplay of
            the organic and technological. Technology should serve Nature, not
            destroy it. Further, how people treat each other is often a
            reflection of how they interpret Nature. For example, it is likely
            that a person who "objectifies" others probably treats Nature itself
            as something that must be "controlled" because we are all
            interconnected by Nature. Everything is alive. The Web of Life is
            the most primary network and it thrives through mutualism.
          </p>
          <div className="flex justify-center my-4">
            <div className="overflow-x-auto">
              <img src="https://letslearntogether.neocities.org/RNDTBL/letters01.png" alt="RNDTBL Letters" className="max-w-full max-h-full" />
            </div>
          </div>
          <p className="mb-4">
            The white letters spell out RNDTBL when followed clockwise. White is
            often a symbol of purity or divinity. The circle has a similar
            connotation, being a representation of the infinite, wholeness, or
            completion. It is without beginning or end, beyond space and time.
            The letters are also at the tips of the branches because they are
            like "fruit", the culimination of something. Nature culminates in a
            transcendent Love when All are united in a mutually constructive
            purpose.
          </p>
          <p className="mb-4">
            • <span className="font-bold">What Features Will RNDTBL Have?</span>
          </p>
          <p className="mb-4">
            <span className="font-bold">Network Graph Visualization:</span> All
            contributions are displayed as nodes in an interactive network graph,
            showing how different ideas and viewpoints connect. As the
            conversation grows, patterns and relationships between concepts become
            visible, creating a living map of collective knowledge.
          </p>
          <p className="mb-4">
            <span className="font-bold">Topic-Based Organization:</span> Each
            world problem or research area has its own dedicated space. Within
            these spaces, multiple parallel discussions can occur simultaneously
            without one dominating another, preserving diverse perspectives.
          </p>
          <p className="mb-4">
            <span className="font-bold">Collaborative Research Tools:</span> Built-in
            features for conducting in-depth research as a group, including shared
            resources, citation management, and the ability to link related
            concepts across different topics.
          </p>
          <p className="mb-4">
            <span className="font-bold">DIY Project Creation:</span> Tools to
            collaboratively design and document ecological engineering projects,
            complete with step-by-step instructions adaptable to different
            environments and contexts.
          </p>
          <p className="mb-4">
            <span className="font-bold">Decentralized Accountability:</span> The
            network structure makes individual contributions and their impacts
            transparent to all participants, fostering mutual accountability
            without traditional moderation hierarchies.
          </p>
          <p className="mb-4">
            <span className="font-bold">Local Implementation Support:</span> Once
            research produces viable solutions, the platform provides resources
            for testing and implementing projects in physical spaces at the local
            level.
          </p>
          <p className="mb-8">
            <span className="font-bold">Equal Voice Architecture:</span> The
            roundtable design ensures that all participants have equal standing,
            with the network topology supporting resilient communication even if
            connections between some members are disrupted.
          </p>
        </div>
      </div>
    </div>;
}