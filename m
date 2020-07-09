Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E532197C0
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Jul 2020 07:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGIFSL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jul 2020 01:18:11 -0400
Received: from ozlabs.org ([203.11.71.1]:53421 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIFSK (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Jul 2020 01:18:10 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B2PZm2SR6z9sSn; Thu,  9 Jul 2020 15:18:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1594271888; bh=huY74zD08xEoQzzcmb++Utd5H1cZU8288xctuON9wUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O0js+zgNb7ws6jTLAind1YB8yKnA4vfBC+iMU6ZUPXuNjg8cepRfncN/qJVbh5TVu
         40srmNlGyIWCCYonsBBndk5dOChZP1I7URH/IEhOnLMiI9rTVGgHpRcvIaWpqGCKoi
         u+taSh819gz/QgXo/91MqbqofX4WivynW/HBWMSbWnWZL6h8rDaWFyf1ljahlt4Xph
         cXaZLr7YUMxLHDiQK2xarr+bvWAKBZh1Vs5OiZileECHXjOgAS3E9xxmgb3ize8aqR
         XPl3WMAsNU5VHjRvATWhkhWeZitSzdb/qYm5XIsKuff9vcpVxyBYsyLmoMkffh5iU+
         BLqDybuLS3bVA==
Date:   Thu, 9 Jul 2020 15:18:03 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au
Subject: Re: [RFC PATCH v0 2/2] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in
 nested KVM
Message-ID: <20200709051803.GC2822576@thinks.paulus.ozlabs.org>
References: <20200703104420.21349-1-bharata@linux.ibm.com>
 <20200703104420.21349-3-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703104420.21349-3-bharata@linux.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 03, 2020 at 04:14:20PM +0530, Bharata B Rao wrote:
> In the nested KVM case, replace H_TLB_INVALIDATE by the new hcall
> H_RPT_INVALIDATE if available. The availability of this hcall
> is determined from "hcall-rpt-invalidate" string in ibm,hypertas-functions
> DT property.

What are we going to use when nested KVM supports HPT guests at L2?
L1 will need to do partition-scoped tlbies with R=0 via a hypercall,
but H_RPT_INVALIDATE says in its name that it only handles radix
page tables (i.e. R=1).

Paul.
