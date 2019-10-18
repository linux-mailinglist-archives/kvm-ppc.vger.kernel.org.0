Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CB7DBD0C
	for <lists+kvm-ppc@lfdr.de>; Fri, 18 Oct 2019 07:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfJRFap (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 18 Oct 2019 01:30:45 -0400
Received: from ozlabs.org ([203.11.71.1]:43131 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbfJRFap (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 18 Oct 2019 01:30:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46vW4j556zz9sPF; Fri, 18 Oct 2019 14:00:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571367653; bh=Un3FmhVENxAIGmN4EhILnWeEZRlRNIZ61ifl2W3Z37o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRThZA6Sy8jco4Qp9JuyQtlnYpcc16jjWKqf8VyyrXQ8mNTwQQl/MzYCIf0J9sEpN
         1RnrSw3SHE4DSrtpK1XnFpm8fe3ASteM1MqUx+MPHsa/J5nSMbwRx48opw9tNXpVFg
         SThjXFgxjxrm9/BS43rUPAlBTjdrQkzmAuGhPd/je3K2OodOwGPk3i6M2wbeg6U2ew
         7mI4NjgZW+Iv0AArtugNeipEkVjT+IPLPjufB7KphuzRhS+DKdOZuAhR7Rn859EN1w
         u6ppMxJ5p2Z78+XJEK7/4QnoUWwV4HHUILtu12a2745FI+oM5gW7sECHUinKEmw7Cd
         3qt7vPyIdnRkg==
Date:   Fri, 18 Oct 2019 14:00:49 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v9 2/8] KVM: PPC: Move pages between normal and secure
 memory
Message-ID: <20191018030049.GA907@oak.ozlabs.ibm.com>
References: <20190925050649.14926-1-bharata@linux.ibm.com>
 <20190925050649.14926-3-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925050649.14926-3-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 25, 2019 at 10:36:43AM +0530, Bharata B Rao wrote:
> Manage migration of pages betwen normal and secure memory of secure
> guest by implementing H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
> 
> H_SVM_PAGE_IN: Move the content of a normal page to secure page
> H_SVM_PAGE_OUT: Move the content of a secure page to normal page
> 
> Private ZONE_DEVICE memory equal to the amount of secure memory
> available in the platform for running secure guests is created.
> Whenever a page belonging to the guest becomes secure, a page from
> this private device memory is used to represent and track that secure
> page on the HV side. The movement of pages between normal and secure
> memory is done via migrate_vma_pages() using UV_PAGE_IN and
> UV_PAGE_OUT ucalls.

As we discussed privately, but mentioning it here so there is a
record:  I am concerned about this structure

> +struct kvmppc_uvmem_page_pvt {
> +	unsigned long *rmap;
> +	struct kvm *kvm;
> +	unsigned long gpa;
> +};

which keeps a reference to the rmap.  The reference could become stale
if the memslot is deleted or moved, and nothing in the patch series
ensures that the stale references are cleaned up.

If it is possible to do without the long-term rmap reference, and
instead find the rmap via the memslots (with the srcu lock held) each
time we need the rmap, that would be safer, I think, provided that we
can sort out the lock ordering issues.

Paul.
