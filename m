Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C8372FD7
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 May 2021 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhEDSiq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 May 2021 14:38:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230086AbhEDSio (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 May 2021 14:38:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144IWlql003724;
        Tue, 4 May 2021 14:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=EDsTIsMyOgbB1j3Z8yy4M20ccVYQAHcvYJCex0x5/ww=;
 b=hCtUV8bfuBWr/TVFe7Og1/VbFq/IRtFXWoKFUivsCqOxATrewgqP6Fm2+5t+R1yN4F5D
 vrUghqx++60kvN+OcWFt0kKkrAPvczBE99WCoDLDHkqd/qhy6nGR5aS1xujL5TwGOLmN
 aVTCPkhKwp5O7+gQHHzMAmYLqThaYmk+Xw4YdvvoR3HxKN8c5RpYcPBaBxOXMUzbA/Od
 P7w34Q2TXZ5Vli75jj8POT+G1OxX1qlUe0bMuaj1BwAZpyuMcWLrXARTPRX3Qz42bMxh
 MM6jkUNwe8JKQXRPgeb7VWFVhOG7TiZ4jCDGr7/M+oWBzTeMknLRjvY7Pav5iASD2HH9 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bajmj7mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 14:37:38 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 144IX6SD004473;
        Tue, 4 May 2021 14:37:37 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bajmj7md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 14:37:37 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 144ISTTJ005205;
        Tue, 4 May 2021 18:37:37 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 388xm9d47j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 18:37:37 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 144IbZ8F34996700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 May 2021 18:37:36 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE4978060;
        Tue,  4 May 2021 18:37:35 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C2DD7805C;
        Tue,  4 May 2021 18:37:35 +0000 (GMT)
Received: from localhost (unknown [9.211.49.100])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  4 May 2021 18:37:34 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Subject: Re: [PATCH v3 1/2] KVM: PPC: Book3S HV: Sanitise vcpu registers in
 nested path
In-Reply-To: <1620115928.pogd4nj1qc.astroid@bobo.none>
References: <20210415230948.3563415-1-farosas@linux.ibm.com>
 <20210415230948.3563415-2-farosas@linux.ibm.com>
 <1619833560.k4eybr40bg.astroid@bobo.none>
 <YJDNbFQlB9DHnI6Z@thinks.paulus.ozlabs.org>
 <1620105163.ok9nw6k5yz.astroid@bobo.none>
 <YJD5lwY4JXyS1VgH@thinks.paulus.ozlabs.org>
 <1620115928.pogd4nj1qc.astroid@bobo.none>
Date:   Tue, 04 May 2021 15:37:32 -0300
Message-ID: <87mtta1h1v.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9OaZE3BgUE6TjGvjPQyWUOVjuoSV0O1c
X-Proofpoint-ORIG-GUID: BX1fOBompBgt98_E5dKoy5-uAF6M1aT3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=712
 clxscore=1015 suspectscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040122
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> An error message when you try to start the nested guest telling you
> pass -machine cap-htm=off would be better... I guess that should
> really all work with caps etc today though so TM's a bad example.
> But assume we don't have a cap for the bit we disable? Maybe we
> should have caps for all HFSCR bits, or I'm just worried about
> something not very important.

I'm avoiding returning an error from H_ENTER_NESTED at first run
specifically because of this. I think it interferes with L1 migration.

Say we have an L1 that has an workload that involves nested guests. It
can boot and run them just fine (i.e. it uses the same HFSCR value for
its guests as L0). If we migrate that L1 into a host that uses different
HFSCR bits and therefore will always fail the H_ENTER_NESTED, that is
effectively the same as migrating into a host that does not provide
KVM_CAP_PPC_NESTED_HV.

We would need some way to inform the migration code that the remote host
will not allow L1 to run nested guests with that particular HFSCR value
so that it can decide whether that host is a suitable migration
target. Otherwise we're migrating the guest into a host that will not
allow its operation to continue.

Returning an error later on during the nested guest lifetime I think it
is less harmful, but nothing really went wrong with the hypercall. It
did its job and ran L2 like L1 asked, although it ignored some bits. Can
we say that L1 misconfigured L2 when there is no way for L1 to negotiate
which bits it can use? The same set of bits could be considered valid by
another L0. It seems that as long as we hardcode some bits we shouldn't
fail the hcall because of them.

I think since this is all a bit theoretical right now, forwarding a
program interrupt into L1 is a good less permanent solution for the
moment, it does not alter the hcall's API and if we start stumbling into
similar issues in the future we'll have more information then to come up
with a proper solution.

>
> Thanks,
> Nick
