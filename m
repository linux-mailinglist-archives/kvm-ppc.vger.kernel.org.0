Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52F846ED0
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFOHrt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:47:49 -0400
Received: from ozlabs.org ([203.11.71.1]:46999 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfFOHrs (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:47:48 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45QqMQ68b2z9sNT; Sat, 15 Jun 2019 17:47:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584866; bh=Omhq+JfRZdaBwAdpC7ZMYBk9IkvNPM4ETCl/bppBLP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SYwry4YVdi1T2o5VEEsKyPMbd3wqwA4NHhCqKjlzzhHPseX72gCQzM7tl3ABvBcQ+
         dhu7MjyeTDmSpxevdX8s2ibjbwFuvej4/KKFQpG/nu2as2W/a+GEUkicKmKkci55Xy
         axIzqd87vr3K1pLVzu58DfR2vxVyJeXpvxwSUmvgKNA3P69DMQo0NBjTaFIwLR7poI
         KK/ShRl8i3Q7hHkZsTkyeCs55htDxFhKhambnmHH0j9YmLWWzgQEYfLwtT9ql8vJ5V
         3XlblyH+4McHXfzr4qvxB/DhHe/prTgbG60V+rY41fCTjgxfw4eAMr07QTDkJbUoR9
         lk+KGfwfMeRmQ==
Date:   Sat, 15 Jun 2019 17:47:43 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 9/9] KVM: PPC: Ultravisor: Check for MSR_S during
 hv_reset_msr
Message-ID: <20190615074743.GF24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-10-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-10-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:14PM -0300, Claudio Carvalho wrote:
> From: Michael Anderson <andmike@linux.ibm.com>
> 
>  - Check for MSR_S so that kvmppc_set_msr will include. Prior to this

Will include what? "it" maybe?

>    change return to guest would not have the S bit set.
> 
>  - Patch based on comment from Paul Mackerras <pmac@au1.ibm.com>
> 
> Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>

but you should reword the commit message fix that first sentence.

Paul.
