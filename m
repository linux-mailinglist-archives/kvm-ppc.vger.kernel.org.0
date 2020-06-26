Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC0820AD79
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jun 2020 09:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgFZHoP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Jun 2020 03:44:15 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:34100 "EHLO
        3.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbgFZHoP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Jun 2020 03:44:15 -0400
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 03:44:14 EDT
Received: from player734.ha.ovh.net (unknown [10.108.54.34])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 2ED41241F84
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Jun 2020 09:27:03 +0200 (CEST)
Received: from kaod.org (lfbn-tou-1-921-245.w86-210.abo.wanadoo.fr [86.210.152.245])
        (Authenticated sender: clg@kaod.org)
        by player734.ha.ovh.net (Postfix) with ESMTPSA id 4F79413A000E6;
        Fri, 26 Jun 2020 07:26:52 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-95G0018ba46917-0696-40ce-8ee4-92facd6b3767,4AA08B4753365576F5C892DCFEC488B61DD07F5F) smtp.auth=clg@kaod.org
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
Message-ID: <d5aa6dea-0126-724d-2d1e-0726584a1dbd@kaod.org>
Date:   Fri, 26 Jun 2020 09:26:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11765372554848930790
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudeltddguddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuhffvfhfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepheevheejjefhtedvueeghfeiffduleeijeehteeuvdfgheeikeevffeghfeviefhnecukfhppedtrddtrddtrddtpdekiedrvddutddrudehvddrvdegheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejfeegrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

[ ...  ]

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

This is really a PowerVM optimization. 

> The CPU setup for XIVE needs a cleanup also. There is no need to allocate
> interrupts for IPIs anymore in that case.

We need to keep these for the other cores. The XIVE layer is unchanged.
 
C. 
