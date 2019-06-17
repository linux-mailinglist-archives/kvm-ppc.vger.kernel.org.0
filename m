Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4247E17
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 11:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfFQJPh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 05:15:37 -0400
Received: from 13.mo4.mail-out.ovh.net ([178.33.251.8]:34227 "EHLO
        13.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfFQJPh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 Jun 2019 05:15:37 -0400
Received: from player168.ha.ovh.net (unknown [10.109.143.189])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 1225E1F0BBB
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Jun 2019 11:06:40 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player168.ha.ovh.net (Postfix) with ESMTPSA id A99566CFA4E2;
        Mon, 17 Jun 2019 09:06:34 +0000 (UTC)
Subject: Re: [PATCH 0/2] Fix handling of h_set_dawr
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mikey@neuling.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20190617071619.19360-1-sjitindarsingh@gmail.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <87e219c8-1db7-9976-03ce-5a566a8df7ab@kaod.org>
Date:   Mon, 17 Jun 2019 11:06:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617071619.19360-1-sjitindarsingh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6350075477084113851
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedguddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/06/2019 09:16, Suraj Jitindar Singh wrote:
> Series contains 2 patches to fix the host in kernel handling of the hcall
> h_set_dawr.
> 
> First patch from Michael Neuling is just a resend added here for clarity.
> 
> Michael Neuling (1):
>   KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()
> 
> Suraj Jitindar Singh (1):
>   KVM: PPC: Book3S HV: Only write DAWR[X] when handling h_set_dawr in
>     real mode



Reviewed-by: Cédric Le Goater <clg@kaod.org>

and 

Tested-by: Cédric Le Goater <clg@kaod.org>


but I see slowdowns in nested as if the IPIs were not delivered. Have we
touch this part in 5.2 ? 

Thanks,

C.

