Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269D920B097
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jun 2020 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFZLfU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Jun 2020 07:35:20 -0400
Received: from 8.mo179.mail-out.ovh.net ([46.105.75.26]:55742 "EHLO
        8.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFZLfU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Jun 2020 07:35:20 -0400
X-Greylist: delayed 12600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 07:35:19 EDT
Received: from player698.ha.ovh.net (unknown [10.108.57.226])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 5DB5816E645
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Jun 2020 09:56:07 +0200 (CEST)
Received: from kaod.org (lfbn-tou-1-921-245.w86-210.abo.wanadoo.fr [86.210.152.245])
        (Authenticated sender: clg@kaod.org)
        by player698.ha.ovh.net (Postfix) with ESMTPSA id AA90E13BEFEA5;
        Fri, 26 Jun 2020 07:55:57 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-98R0029532a19b-89da-44a0-a978-e72fb07fdba4,4AA08B4753365576F5C892DCFEC488B61DD07F5F) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] powerpc/pseries: Use doorbells even if XIVE is available
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Anton Blanchard <anton@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
References: <20200624134724.2343007-1-npiggin@gmail.com>
 <87r1u4aqzm.fsf@mpe.ellerman.id.au>
 <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
Message-ID: <ec235efc-0808-1f7a-498f-286c6addc028@kaod.org>
Date:   Fri, 26 Jun 2020 09:55:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12256264912732851174
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudeltddguddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuhffvfhfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepheevheejjefhtedvueeghfeiffduleeijeehteeuvdfgheeikeevffeghfeviefhnecukfhppedtrddtrddtrddtpdekiedrvddutddrudehvddrvdegheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

>>> An option vector (or dt-cpu-ftrs) could be defined to disable msgsndp
>>> to get KVM performance back.
> 
> An option vector would require a PAPR change. Unless the architecture 
> reserves some bits for the implementation, but I don't think so. Same
> for CAS.
> 
>> Qemu/KVM populates /proc/device-tree/hypervisor, so we *could* look at
>> that. Though adding PowerVM/KVM specific hacks is obviously a very
>> slippery slope.
> 
> QEMU could advertise a property "emulated-msgsndp", or something similar, 
> which would be interpreted by Linux as a CPU feature and taken into account 
> when doing the IPIs.

Could we remove msgsndp support from HFSCR in KVM and test it in pseries ? 

C.
