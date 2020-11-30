Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875962C844D
	for <lists+kvm-ppc@lfdr.de>; Mon, 30 Nov 2020 13:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgK3Msz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 30 Nov 2020 07:48:55 -0500
Received: from smtpout1.mo804.mail-out.ovh.net ([79.137.123.220]:51287 "EHLO
        smtpout1.mo804.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgK3Msz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 30 Nov 2020 07:48:55 -0500
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.48])
        by mo804.mail-out.ovh.net (Postfix) with ESMTPS id AAA5776AA6CC;
        Mon, 30 Nov 2020 13:48:11 +0100 (CET)
Received: from kaod.org (37.59.142.97) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 30 Nov
 2020 13:47:44 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-97G002978f41c7-e800-44a0-8e37-0dccf4f80915,
                    54E7F54749740F6D21A4FFD7F03B08EA4E155DE3) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix vCPU id sanity check
To:     Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
References: <160673876747.695514.1809676603724514920.stgit@bahia.lan>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <a25aaf4b-fdc9-89b1-e518-f0aa273c49bb@kaod.org>
Date:   Mon, 30 Nov 2020 13:47:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <160673876747.695514.1809676603724514920.stgit@bahia.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 74709152-3782-4f2d-a519-aded61145703
X-Ovh-Tracer-Id: 16856973407783258918
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrudeitddggeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeejkeduueduveelgeduueegkeelffevledujeetffeivdelvdfgkeeufeduheehfeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehgrhhouhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/30/20 1:19 PM, Greg Kurz wrote:
> Commit 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP block size
> configurable") updated kvmppc_xive_vcpu_id_valid() in a way that
> allows userspace to trigger an assertion in skiboot and crash the host:
> 
> [  696.186248988,3] XIVE[ IC 08  ] eq_blk != vp_blk (0 vs. 1) for target 0x4300008c/0
> [  696.186314757,0] Assert fail: hw/xive.c:2370:0
> [  696.186342458,0] Aborting!
> xive-kvCPU 0043 Backtrace:
>  S: 0000000031e2b8f0 R: 0000000030013840   .backtrace+0x48
>  S: 0000000031e2b990 R: 000000003001b2d0   ._abort+0x4c
>  S: 0000000031e2ba10 R: 000000003001b34c   .assert_fail+0x34
>  S: 0000000031e2ba90 R: 0000000030058984   .xive_eq_for_target.part.20+0xb0
>  S: 0000000031e2bb40 R: 0000000030059fdc   .xive_setup_silent_gather+0x2c
>  S: 0000000031e2bc20 R: 000000003005a334   .opal_xive_set_vp_info+0x124
>  S: 0000000031e2bd20 R: 00000000300051a4   opal_entry+0x134
>  --- OPAL call token: 0x8a caller R1: 0xc000001f28563850 ---
> 
> XIVE maintains the interrupt context state of non-dispatched vCPUs in
> an internal VP structure. We allocate a bunch of those on startup to
> accommodate all possible vCPUs. Each VP has an id, that we derive from
> the vCPU id for efficiency:
> 
> static inline u32 kvmppc_xive_vp(struct kvmppc_xive *xive, u32 server)
> {
> 	return xive->vp_base + kvmppc_pack_vcpu_id(xive->kvm, server);
> }
> 
> The KVM XIVE device used to allocate KVM_MAX_VCPUS VPs. This was
> limitting the number of concurrent VMs because the VP space is
> limited on the HW. Since most of the time, VMs run with a lot less
> vCPUs, commit 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP
> block size configurable") gave the possibility for userspace to
> tune the size of the VP block through the KVM_DEV_XIVE_NR_SERVERS
> attribute.
> 
> The check in kvmppc_pack_vcpu_id() was changed from
> 
> 	cpu < KVM_MAX_VCPUS * xive->kvm->arch.emul_smt_mode
> 
> to
> 
> 	cpu < xive->nr_servers * xive->kvm->arch.emul_smt_mode
> 
> The previous check was based on the fact that the VP block had
> KVM_MAX_VCPUS entries and that kvmppc_pack_vcpu_id() guarantees
> that packed vCPU ids are below KVM_MAX_VCPUS. We've changed the
> size of the VP block, but kvmppc_pack_vcpu_id() has nothing to
> do with it and it certainly doesn't ensure that the packed vCPU
> ids are below xive->nr_servers. kvmppc_xive_vcpu_id_valid() might
> thus return true when the VM was configured with a non-standard
> VSMT mode, even if the packed vCPU id is higher than what we
> expect. We end up using an unallocated VP id, which confuses
> OPAL. The assert in OPAL is probably abusive and should be
> converted to a regular error that the kernel can handle, but
> we shouldn't really use broken VP ids in the first place.
> 
> Fix kvmppc_xive_vcpu_id_valid() so that it checks the packed
> vCPU id is below xive->nr_servers, which is explicitly what we
> want.
> 
> Fixes: 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP block size configurable")
> Cc: stable@vger.kernel.org # v5.5+
> Signed-off-by: Greg Kurz <groug@kaod.org>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>  arch/powerpc/kvm/book3s_xive.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index 85215e79db42..a0ebc29f30b2 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -1214,12 +1214,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
>  static bool kvmppc_xive_vcpu_id_valid(struct kvmppc_xive *xive, u32 cpu)
>  {
>  	/* We have a block of xive->nr_servers VPs. We just need to check
> -	 * raw vCPU ids are below the expected limit for this guest's
> -	 * core stride ; kvmppc_pack_vcpu_id() will pack them down to an
> -	 * index that can be safely used to compute a VP id that belongs
> -	 * to the VP block.
> +	 * packed vCPU ids are below that.
>  	 */
> -	return cpu < xive->nr_servers * xive->kvm->arch.emul_smt_mode;
> +	return kvmppc_pack_vcpu_id(xive->kvm, cpu) < xive->nr_servers;
>  }
>  
>  int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp)
> 
> 

