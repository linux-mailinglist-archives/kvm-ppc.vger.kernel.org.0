Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1518F46ED1
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfFOHrt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:47:49 -0400
Received: from ozlabs.org ([203.11.71.1]:33215 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfFOHrs (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:47:48 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45QqMR0FTCz9sNl; Sat, 15 Jun 2019 17:47:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584867; bh=RbVxzic/utIowZwLvmsu0ZqoiFt+kS5VBsZdtW+Utcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KTBzlzh+vKbi32BAVrbFzAP8ZM8khVQoraLTz72U4uRj7oMEImg8+W93wiW5V0gXI
         ZEpWauGXSgcX/5cnNlH4vSEOomomYA2sLQhsa2PD71CN23j5ZT5CyvZ2NWkVAEvINJ
         GZB0CxHVHVzvrysEdmAYNDUhH1WWhftXdOkiaz0kCLNPxvXDN/jbqnV1yIZQ/UtfNq
         fbgpRI59KkSFj23SIcT4DLepKdeKbQ88QpOdJSTU0hcN/l52oSHagT79kvq/enb0lN
         P+7AT1nympiM2xIPoOUCraD1XuEAC+344cmM6gEE93W0npUa6xmhd55bv/55uurDtF
         c6NcXiGObMKHw==
Date:   Sat, 15 Jun 2019 17:43:34 +1000
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
Subject: Re: [PATCH v3 7/9] KVM: PPC: Ultravisor: Restrict LDBAR access
Message-ID: <20190615074334.GD24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-8-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-8-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:12PM -0300, Claudio Carvalho wrote:
> When the ultravisor firmware is available, it takes control over the
> LDBAR register. In this case, thread-imc updates and save/restore
> operations on the LDBAR register are handled by ultravisor.
> 
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>

Just a note on the signed-off-by: it's a bit weird to have Ram's
signoff when he is neither the author nor the sender of the patch.
The author is assumed to be Claudio; if that is not correct then the
patch should have a From: line at the start telling us who the author
is, and ideally that person should have a signoff line before
Claudio's signoff as the sender of the patch.

Paul.
