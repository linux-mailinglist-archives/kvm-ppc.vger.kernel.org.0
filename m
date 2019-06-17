Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C6E48107
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbfFQLkc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 07:40:32 -0400
Received: from ozlabs.org ([203.11.71.1]:44483 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfFQLkc (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 07:40:32 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S8R16ZTPz9sNR; Mon, 17 Jun 2019 21:40:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560771629; bh=CDgRSuuCpsIKWfcE24KOGkwYw1tW35bw6uPLWPHknvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bAubgwMxHtGYS8gMdb85LJE5ubV1LOMLvaAGQvRDjeVPeoO4xez4+ME7LGltSfBPh
         VwwPybvGzGax0u6q5dnG4vQv+BdAbLnIm0t10AvRkz6PcTKHyOWF7kFSdMzYurZvHc
         N0ZlodBU1HbFkb3f/kk2IjLum0I8nR9JLSbKk4H2c3mUdruTXoFxMZuquoYDq3a5nu
         g2gxpLdElFOgdtigsAmZxgcar9CQa9cQl3ca0xQGzpWXZYKM/H7Gf5wp1/mCgzdXp0
         Tf5Uw2wzU2rRo0UU/u/PWezVrE9rQZpV+xLQHJGLWgYjsuqCj3N6D7VNY1fAFAnpdG
         hxjofkvqNga2Q==
Date:   Mon, 17 Jun 2019 16:32:54 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Cc:     kvm-ppc@vger.kernel.org, farosas@linux.ibm.com
Subject: Re: [PATCH] KVM: PPC: Book3S PR: fix software breakpoints
Message-ID: <20190617063254.qkk6jwx5ud4zit73@oak.ozlabs.ibm.com>
References: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jun 14, 2019 at 07:57:45PM +0100, Mark Cave-Ayland wrote:
> QEMU's kvm_handle_debug() function identifies software breakpoints by checking
> for a value of 0 in kvm_debug_exit_arch's status field. Since this field isn't
> explicitly set to 0 when the software breakpoint instruction is detected, any
> previous non-zero value present causes a hang in QEMU as it tries to process
> the breakpoint instruction incorrectly as a hardware breakpoint.
> 
> Ensure that the kvm_debug_exit_arch status field is set to 0 when the software
> breakpoint instruction is detected (similar to the existing logic in booke.c
> and e500_emulate.c) to restore software breakpoint functionality under Book3S
> PR.
> 
> Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> ---
>  arch/powerpc/kvm/emulate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
> index bb4d09c1ad56..6fca38ca791f 100644
> --- a/arch/powerpc/kvm/emulate.c
> +++ b/arch/powerpc/kvm/emulate.c
> @@ -271,6 +271,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  		 */
>  		if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>  			run->exit_reason = KVM_EXIT_DEBUG;
> +			run->debug.arch.status = 0;
>  			run->debug.arch.address = kvmppc_get_pc(vcpu);
>  			emulated = EMULATE_EXIT_USER;
>  			advance = 0;

Thanks, applied to my kvm-ppc-next branch.

Paul.
