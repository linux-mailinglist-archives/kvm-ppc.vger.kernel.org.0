Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6F822B4F3
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGWRee (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 13:34:34 -0400
Received: from 7.mo6.mail-out.ovh.net ([46.105.59.196]:48784 "EHLO
        7.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGWRed (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Jul 2020 13:34:33 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2020 13:34:33 EDT
Received: from player726.ha.ovh.net (unknown [10.110.171.40])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 4FF882208EA
        for <kvm-ppc@vger.kernel.org>; Thu, 23 Jul 2020 19:18:15 +0200 (CEST)
Received: from kaod.org (bad36-1-78-202-132-1.fbx.proxad.net [78.202.132.1])
        (Authenticated sender: clg@kaod.org)
        by player726.ha.ovh.net (Postfix) with ESMTPSA id 31C2D148D3F16;
        Thu, 23 Jul 2020 17:18:06 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-106R00656480056-5979-4c0d-b1fd-dc0742c8c4b8,
                    0360426414082D1FC3E0C3FF9A362FC9406E86E3) smtp.auth=clg@kaod.org
Subject: Re: [PATCH v2 0/3] powerpc/pseries: IPI doorbell improvements
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org
References: <20200630115034.137050-1-npiggin@gmail.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <7ff5bf9e-4a04-a773-86a7-73076936819c@kaod.org>
Date:   Thu, 23 Jul 2020 19:18:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630115034.137050-1-npiggin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14291891945715960791
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrhedugdduudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefffdvtddugeeifeduuefghfejgfeigeeigeeltedthefgieeiveeuiefhgeefgfenucfkpheptddrtddrtddrtddpjeekrddvtddvrddufedvrddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjedviedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmqdhpphgtsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 6/30/20 1:50 PM, Nicholas Piggin wrote:
> Since v1:
> - Fixed SMP compile error.
> - Fixed EPAPR / KVM_GUEST breakage.
> - Expanded patch 3 changelog a bit.
> 
> Thanks,
> Nick

I gave the patchset a try on KVM guests (P9 and P8) and PowerVM LPARs (P9).

Looks good.  

Tested-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C. 

> 
> Nicholas Piggin (3):
>   powerpc: inline doorbell sending functions
>   powerpc/pseries: Use doorbells even if XIVE is available
>   powerpc/pseries: Add KVM guest doorbell restrictions
> 
>  arch/powerpc/include/asm/dbell.h     | 63 ++++++++++++++++++++++++++--
>  arch/powerpc/include/asm/firmware.h  |  6 +++
>  arch/powerpc/include/asm/kvm_para.h  | 26 ++----------
>  arch/powerpc/kernel/Makefile         |  5 +--
>  arch/powerpc/kernel/dbell.c          | 55 ------------------------
>  arch/powerpc/kernel/firmware.c       | 19 +++++++++
>  arch/powerpc/platforms/pseries/smp.c | 62 +++++++++++++++++++--------
>  7 files changed, 134 insertions(+), 102 deletions(-)
> 

