Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FF02AA308
	for <lists+kvm-ppc@lfdr.de>; Sat,  7 Nov 2020 08:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgKGHgZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 7 Nov 2020 02:36:25 -0500
Received: from 2.mo51.mail-out.ovh.net ([178.33.255.19]:44905 "EHLO
        2.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgKGHgZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 7 Nov 2020 02:36:25 -0500
X-Greylist: delayed 134994 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2020 02:36:25 EST
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.120])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id A2179234A14;
        Sat,  7 Nov 2020 08:36:22 +0100 (CET)
Received: from kaod.org (37.59.142.100) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 7 Nov 2020
 08:36:21 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-100R003e3b03820-d2b2-4212-ba04-c5f82cbca675,
                    631A0D93C09BF71B9EF4F6053DF0876B02EC8DF7) smtp.auth=groug@kaod.org
Date:   Sat, 7 Nov 2020 08:36:20 +0100
From:   Greg Kurz <groug@kaod.org>
To:     <xiakaixu1987@gmail.com>
CC:     <paulus@ozlabs.org>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] KVM: PPC: Book3S: Assign boolean values to a bool
 variable
Message-ID: <20201107083620.36281484@bahia.lan>
In-Reply-To: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
References: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 2677aa17-f393-4da7-9672-582068393337
X-Ovh-Tracer-Id: 5653706383016171814
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedruddutddguddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthejfedtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnheptefgffffgffgkeegffetkefhhfeuleffvdehvdfgtdfhiedutedvudelgfevveetnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkrghigihugihirgesthgvnhgtvghnthdrtghomh
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat,  7 Nov 2020 14:26:22 +0800
xiakaixu1987@gmail.com wrote:

> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the following coccinelle warnings:
> 
> ./arch/powerpc/kvm/book3s_xics.c:476:3-15: WARNING: Assignment of 0/1 to bool variable
> ./arch/powerpc/kvm/book3s_xics.c:504:3-15: WARNING: Assignment of 0/1 to bool variable
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_xics.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
> index 5fee5a11550d..303e3cb096db 100644
> --- a/arch/powerpc/kvm/book3s_xics.c
> +++ b/arch/powerpc/kvm/book3s_xics.c
> @@ -473,7 +473,7 @@ static void icp_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
>  			arch_spin_unlock(&ics->lock);
>  			local_irq_restore(flags);
>  			new_irq = reject;
> -			check_resend = 0;
> +			check_resend = false;
>  			goto again;
>  		}
>  	} else {
> @@ -501,7 +501,7 @@ static void icp_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
>  			state->resend = 0;
>  			arch_spin_unlock(&ics->lock);
>  			local_irq_restore(flags);
> -			check_resend = 0;
> +			check_resend = false;
>  			goto again;
>  		}
>  	}

