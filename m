Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF246EBD
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfFOHha (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:37:30 -0400
Received: from ozlabs.org ([203.11.71.1]:43717 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfFOHha (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:37:30 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Qq7W41Drz9sDB; Sat, 15 Jun 2019 17:37:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584247; bh=tKoVDInPecXoeEXMW70V2vj5KuXPanLCpYWOumHs1rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdb8QER0aLThSFeUxQAFwQNi7i5uHfosRYjmTturWX2pu+Y46RASWLyKukwMrpK2y
         v3Q+Ut+yaP7nAQCySox+ZasCthS6xSoaYInqpusAr+63FWI0YWanmF6eXu3wI46APk
         +4G7qG43ELE/MH05qLKvmSqifeCfVfq0LC8kAFNWriRPEivN/fiqszUadjh33+Lmyq
         BL+Usp8T1XiSZYbG+umSw0DC9xoSTurrVtuYyyEdbwgcPZSo3wriOpxgRZ2e0pFiRn
         Bc4+zHxYbN7g0Al275AyW3X1jDDpuKAjAWIfOcwnyl2Uxp6iOGgMJfZGm8pVit50NQ
         OaTTxXlYNiELg==
Date:   Sat, 15 Jun 2019 17:37:24 +1000
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
Subject: Re: [PATCH v3 4/9] KVM: PPC: Ultravisor: Add generic ultravisor call
 handler
Message-ID: <20190615073724.GB24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-5-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-5-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:09PM -0300, Claudio Carvalho wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> Add the ucall() function, which can be used to make ultravisor calls
> with varied number of in and out arguments. Ultravisor calls can be made
> from the host or guests.
> 
> This copies the implementation of plpar_hcall().

Again, we will want all of this on every powernv-capable kernel, since
they will all need to do UV_WRITE_PATE, even if they have no other
support for the ultravisor.

Paul.
