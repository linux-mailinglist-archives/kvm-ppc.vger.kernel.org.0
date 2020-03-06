Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4517B45A
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Mar 2020 03:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFCSW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 21:18:22 -0500
Received: from outbound2mad.lav.puc.rediris.es ([130.206.19.139]:14084 "EHLO
        mx01.puc.rediris.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726413AbgCFCSW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Mar 2020 21:18:22 -0500
X-Greylist: delayed 701 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 21:18:21 EST
Received: from sim.rediris.es (mta-out04.sim.rediris.es [130.206.24.46])
        by mx01.puc.rediris.es  with ESMTP id 02626Jg8011643-02626JgA011643
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 6 Mar 2020 03:06:19 +0100
Received: from sim.rediris.es (localhost.localdomain [127.0.0.1])
        by sim.rediris.es (Postfix) with ESMTPS id D9490395CF;
        Fri,  6 Mar 2020 03:06:18 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by sim.rediris.es (Postfix) with ESMTP id 88EDC395D0;
        Fri,  6 Mar 2020 03:06:18 +0100 (CET)
Received: from sim.rediris.es ([127.0.0.1])
        by localhost (mta-out04.sim.rediris.es [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6nCRum6MqbsU; Fri,  6 Mar 2020 03:06:18 +0100 (CET)
Received: from lt-gp.iram.es (mrt-fw.iram.es [150.214.224.223])
        by sim.rediris.es (Postfix) with ESMTPA id 3D4D4395CF;
        Fri,  6 Mar 2020 03:06:16 +0100 (CET)
Date:   Fri, 6 Mar 2020 03:06:07 +0100
From:   Gabriel Paubert <paubert@iram.es>
To:     Gustavo Romero <gromero@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix typos in comments
Message-ID: <20200306020607.GA29843@lt-gp.iram.es>
References: <1583454396-1424-1-git-send-email-gromero@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583454396-1424-1-git-send-email-gromero@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=iram.es; s=DKIM; c=relaxed/relaxed;
 h=date:from:to:cc:subject:message-id:references:mime-version:content-type;
 bh=LW6iXnJ0rHE87BL3g53rbVaF3tktZwumkRX+fbrX5yw=;
 b=mnh5dSkUN7ryd6gTDHzgjWzFhFurfrLs0Wg6pLRRnzQ/4hJq1dYYzc+JI3Vv5jX1cUPAJ4elBnaK
        oxuhzJ12TMoI4n1nTn4msrQ+V8gDl3gAnpF/lgKl9QDt4j5Ti+4M+h1TQFz3t7WuXOYD5SAnyn0B
        gsNJKwUUWVxcjtUhehZj4wZnkLI/6HIENe2PyjHh71PnlfUj+IcM5la26R3pZ3/ysl3ZPVGkpaVM
        mOd4yJoBJqM/iFf42sowsM/Lir5AnaXYCzwfyyP/zmMtb/Qjl4WXx1oKHFXYl8dWfCmU384fu/LZ
        kjB6b7SipOYvFrqxpatkgPm2RAeBcgWDA+r+Jg==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 06, 2020 at 11:26:36AM +1100, Gustavo Romero wrote:
> Fix typos found in comments about the parameter passed
> through r5 to kvmppc_{save,restore}_tm_hv functions.

Actually "iff" is a common shorthand in some fields and not necessarily
a spelling error:

https://en.wikipedia.org/wiki/If_and_only_if

	Gabriel
> 
> Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index dbc2fec..a55dbe8 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -3121,7 +3121,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
>   * Save transactional state and TM-related registers.
>   * Called with r3 pointing to the vcpu struct and r4 containing
>   * the guest MSR value.
> - * r5 is non-zero iff non-volatile register state needs to be maintained.
> + * r5 is non-zero if non-volatile register state needs to be maintained.
>   * If r5 == 0, this can modify all checkpointed registers, but
>   * restores r1 and r2 before exit.
>   */
> @@ -3194,7 +3194,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_SO_BUG)
>   * Restore transactional state and TM-related registers.
>   * Called with r3 pointing to the vcpu struct
>   * and r4 containing the guest MSR value.
> - * r5 is non-zero iff non-volatile register state needs to be maintained.
> + * r5 is non-zero if non-volatile register state needs to be maintained.
>   * This potentially modifies all checkpointed registers.
>   * It restores r1 and r2 from the PACA.
>   */
> -- 
> 1.8.3.1
> 
