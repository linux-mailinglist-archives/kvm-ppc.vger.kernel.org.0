Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7535AFBB1D
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 Nov 2019 22:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKMVu5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 Nov 2019 16:50:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbfKMVu5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 13 Nov 2019 16:50:57 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADLnMDb132887
        for <kvm-ppc@vger.kernel.org>; Wed, 13 Nov 2019 16:50:56 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8rt8jnvk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 13 Nov 2019 16:50:55 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Wed, 13 Nov 2019 21:50:53 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 21:50:50 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADLoCcn44171756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 21:50:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09AF94204B;
        Wed, 13 Nov 2019 21:50:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D272C42042;
        Wed, 13 Nov 2019 21:50:45 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.181.122])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 Nov 2019 21:50:45 +0000 (GMT)
Date:   Wed, 13 Nov 2019 13:50:42 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, sukadev@linux.vnet.ibm.com, hch@lst.de,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Ram Pai <linuxram@linux.ibm.com>
Subject: Re: [PATCH v10 7/8] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191104041800.24527-8-bharata@linux.ibm.com>
 <20191111041924.GA4017@oak.ozlabs.ibm.com>
 <20191112010158.GB5159@oc0525413822.ibm.com>
 <20191112053836.GB10885@oak.ozlabs.ibm.com>
 <20191112075215.GD5159@oc0525413822.ibm.com>
 <20191112113204.GA10178@blackberry>
 <20191112144555.GE5159@oc0525413822.ibm.com>
 <20191113001427.GA17829@oak.ozlabs.ibm.com>
 <20191113063233.GF5159@oc0525413822.ibm.com>
 <20191113211824.GA20535@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113211824.GA20535@blackberry>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19111321-0020-0000-0000-00000385F2FD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111321-0021-0000-0000-000021DC0582
Message-Id: <20191113215042.GG5159@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130180
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Nov 14, 2019 at 08:18:24AM +1100, Paul Mackerras wrote:
> On Tue, Nov 12, 2019 at 10:32:33PM -0800, Ram Pai wrote:
> > On Wed, Nov 13, 2019 at 11:14:27AM +1100, Paul Mackerras wrote:
> > > On Tue, Nov 12, 2019 at 06:45:55AM -0800, Ram Pai wrote:
> > > > On Tue, Nov 12, 2019 at 10:32:04PM +1100, Paul Mackerras wrote:
> > > > > On Mon, Nov 11, 2019 at 11:52:15PM -0800, Ram Pai wrote:
> > > > > > There is subtle problem removing that code from the assembly.
> > > > > > 
> > > > > > If the H_SVM_INIT_ABORT hcall returns to the ultravisor without clearing
> > > > > > kvm->arch.secure_guest, the hypervisor will continue to think that the
> > > > > > VM is a secure VM.   However the primary reason the H_SVM_INIT_ABORT
> > > > > > hcall was invoked, was to inform the Hypervisor that it should no longer
> > > > > > consider the VM as a Secure VM. So there is a inconsistency there.
> > > > > 
> > > > > Most of the checks that look at whether a VM is a secure VM use code
> > > > > like "if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)".  Now
> > > > > since KVMPPC_SECURE_INIT_ABORT is 4, an if statement such as that will
> > > > > take the false branch once we have set kvm->arch.secure_guest to
> > > > > KVMPPC_SECURE_INIT_ABORT in kvmppc_h_svm_init_abort.  So in fact in
> > > > > most places we will treat the VM as a normal VM from then on.  If
> > > > > there are any places where we still need to treat the VM as a secure
> > > > > VM while we are processing the abort we can easily do that too.
> > > > 
> > > > Is the suggestion --  KVMPPC_SECURE_INIT_ABORT should never return back
> > > > to the Ultravisor?   Because removing that assembly code will NOT lead the
> > > 
> > > No.  The suggestion is that vcpu->arch.secure_guest stays set to
> > > KVMPPC_SECURE_INIT_ABORT until userspace calls KVM_PPC_SVM_OFF.
> > 
> > In the fast_guest_return path, if it finds 
> > (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_ABORT) is true, should it return to
> > UV or not?
> > 
> > Ideally it should return back to the ultravisor the first time
> > KVMPPC_SECURE_INIT_ABORT is set, and not than onwards.
> 
> What is ideal about that behavior?  Why would that be a particularly
> good thing to do?

It is following the rule -- "return back to the caller".

RP

-- 
Ram Pai

