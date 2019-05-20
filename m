Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A5C23D75
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392589AbfETQay convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Mon, 20 May 2019 12:30:54 -0400
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:47007 "EHLO
        4.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392408AbfETQax (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 May 2019 12:30:53 -0400
X-Greylist: delayed 16798 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 12:30:52 EDT
Received: from player795.ha.ovh.net (unknown [10.108.35.90])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 43FFA17942E
        for <kvm-ppc@vger.kernel.org>; Mon, 20 May 2019 11:23:50 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player795.ha.ovh.net (Postfix) with ESMTPSA id DCF8A5E0B299;
        Mon, 20 May 2019 09:23:43 +0000 (UTC)
Date:   Mon, 20 May 2019 11:23:43 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S HV: XIVE: fix the enforced limit
 on the vCPU identifier
Message-ID: <20190520112343.7e724abb@bahia.lan>
In-Reply-To: <20190520071514.9308-4-clg@kaod.org>
References: <20190520071514.9308-1-clg@kaod.org>
        <20190520071514.9308-4-clg@kaod.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 8225261772183607691
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 20 May 2019 09:15:14 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> When a vCPU is connected to the KVM device, it is done using its vCPU
> identifier in the guest. Fix the enforced limit on the vCPU identifier
> by taking into account the SMT mode.
> 

Reviewed-by: Greg Kurz <groug@kaod.org>

> Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/kvm/book3s_xive_native.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 3fdea6bf4e97..25b6b0e2d02a 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -109,7 +109,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
>  		return -EPERM;
>  	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
>  		return -EBUSY;
> -	if (server_num >= KVM_MAX_VCPUS) {
> +	if (server_num >= (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
>  		pr_devel("Out of bounds !\n");
>  		return -EINVAL;
>  	}

